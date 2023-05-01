// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// Include necessary functions that give artists , users the ownership of nft token
// These are basically some conventions that standardize our code for the usage of various online wallets and nft contracts
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MusicNFTMarketplace is ERC721("DAppFi", "DAPP"), Ownable {
    // Where are all the files
    string public baseURI =
    "https://bafybeifyoypgamb5itzryyjp2mejtn6eovoamk4b4xwg6h4b4ehvkjsfmm.ipfs.nftstorage.link/";
    // bafybeibdut42kuniewo36ddgj5sbev4sybdqll67ba6cebhi7xtcl6kaxi
        // "https://bafybeibiq5nfamauzfovbkrdeaovgnpuphakszmljqmzc7t7tb7f6xqffu.ipfs.nftstorage.link/";
        // "https://bafybeidhjjbjonyqcahuzlpt7sznmh4xrlbspa3gstop5o47l6gsiaffee.ipfs.nftstorage.link/";
        // This
        // "https://bafybeidhjjbjonyqcahuzlpt7sznmh4xrlbspa3gstop5o47l6gsiaffee.ipfs.nftstorage.link/";
        // "https://bafybeibdut42kuniewo36ddgj5sbev4sybdqll67ba6cebhi7xtcl6kaxi.ipfs.nftstorage.link/";
        // "https://bafybeibiq5nfamauzfovbkrdeaovgnpuphakszmljqmzc7t7tb7f6xqffu.ipfs.nftstorage.link/";

    string public baseExtension = ".json";
    // address of the artist who dropped the album so that we know whom to pay the royalty fee 
    // upon transaction
    address public artist;
    // We also need to know the amount of royalty fee
    uint256 public royaltyFee;

    // Our own custom datatype to define the marketItem
    struct MarketItem {
        uint256 tokenId;
        address payable seller;       // Seller who is listing his bought nft at the marketplace
        uint256 price;              // price at which ihe is listing
    }
    // To contain all marketitems(nft token in our case)
    MarketItem[] public marketItems;

    // used in function buyToken
    event MarketItemBought(
        uint256 indexed tokenId,
        address indexed seller,
        address buyer,
        uint256 price
    );
    // used in function resellToken
    event MarketItemRelisted(
        uint256 indexed tokenId,
        address indexed seller,
        uint256 price
    );

    /* In constructor we initalize royalty fee, artist address and prices of music nfts*/
    // Since we know that a constructor fn is called once only upon its creation
    // So here we store the address of the artist who uploaaded the song

    // We are also going to mark this constructor as payable so that the deployer can
    // pay the ether upon royalty to cover the royalty fee for listing his nft on marketplace
    constructor( 
        uint256 _royaltyFee,
        address _artist,
        uint256[] memory _prices
    ) payable {
        require(
            _prices.length * _royaltyFee <= msg.value,
            "Deployer must pay royalty fee for each token listed on the marketplace"
        );
        royaltyFee = _royaltyFee;
        artist = _artist;
        for (uint8 i = 0; i < _prices.length; i++) {
            // listed price must be greater than 0
            require(_prices[i] > 0, "Price must be greater than 0");
            // Now we are again going to list this nft on the marketplace
            _mint(address(this), i);
            // We push this created method again to the marketpllace
            marketItems.push(MarketItem(i, payable(msg.sender), _prices[i]));
        }
    }


    /* These functions will consume gas */

    /* Updates the royalty fee of the contract */
    // Only the owner can update his royalty fee
    // Only owner can modify it
    function updateRoyaltyFee(uint256 _royaltyFee) external onlyOwner {
        royaltyFee = _royaltyFee;
    }


    /* Creates the sale of a music nft listed on the marketplace */
    /* Transfers ownership of the nft, as well as funds between parties */
    function buyToken(uint256 _tokenId) external payable {
        uint256 price = marketItems[_tokenId].price;  // Price to pay
        address seller = marketItems[_tokenId].seller;  // Seller to whom the price is to be paid
        require(
            msg.value == price,
            "Please send the asking price in order to complete the purchase"
        );
        marketItems[_tokenId].seller = payable(address(0));   // Update the seller field to the buyer after purchase
        _transfer(address(this), msg.sender, _tokenId);  // Transfer ownership
        payable(artist).transfer(royaltyFee);   // Transfer royalty fee to original upon transaction
        payable(seller).transfer(msg.value);    // Transfer the seller the payable amount
        emit MarketItemBought(_tokenId, seller, msg.sender, price);
    }


    /* Allows someone to resell their music nft */
    // Owner of the nft has to resell a token
    function resellToken(uint256 _tokenId, uint256 _price) external payable {
        // Royalty
        require(msg.value == royaltyFee, "Must pay royalty");
        // Resell price > 0
        require(_price > 0, "Price must be greater than zero");
        // Asking price
        marketItems[_tokenId].price = _price;
        // The amount will be paid upon buy to this seller's address
        marketItems[_tokenId].seller = payable(msg.sender);

        // Transfer ownership from owner to the contract
        _transfer(msg.sender, address(this), _tokenId);
        emit MarketItemRelisted(_tokenId, msg.sender, _price);
    }



    /* Won't consume gas only to retreive somethings */


    /* Fetches all the tokens currently listed for sale */
    function getAllUnsoldTokens() external view returns (MarketItem[] memory) {
        uint256 unsoldCount = balanceOf(address(this));
        MarketItem[] memory tokens = new MarketItem[](unsoldCount);
        uint256 currentIndex;
        for (uint256 i = 0; i < marketItems.length; i++) {
            // If token seller is not a zero address => Item is not yet bought by anyone
            if (marketItems[i].seller != address(0)) {
                tokens[currentIndex] = marketItems[i];
                currentIndex++;
            }
        }
        return (tokens);
    }

    /* Fetches all the tokens owned by the user */
    function getMyTokens() external view returns (MarketItem[] memory) {
        uint256 myTokenCount = balanceOf(msg.sender);
        MarketItem[] memory tokens = new MarketItem[](myTokenCount);
        uint256 currentIndex;
        for (uint256 i = 0; i < marketItems.length; i++) {
            if (ownerOf(i) == msg.sender) {
                tokens[currentIndex] = marketItems[i];
                currentIndex++;
            }
        }
        return (tokens);
    }

    /* Internal function that gets the baseURI initialized in the constructor */
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }
}
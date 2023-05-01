import logo from './logo1.jpg';
import './App.css';
import mus from '../../mus.png';
import mus2 from '../../mus2.png';
import mus3 from '../../mus3.png';
 
function Welcome() {
  return (
    <div style={{backgroundColor: 'black'}}>
      <div className="container-fluid mt-0">
        <div className="row">
          <main role="main" className="col-lg-12 d-flex text-center">
            <div className="content mx-auto mt-1">
              <a
                href="/"
                target="_blank"
                rel="noopener noreferrer"
              >
                {/* <img src={logo} className="App-logo" alt="logo"/> */}
              </a>
              <h1 className= "mt-1" style={{ color: 'orange' , fontWeight: 'bold' }}>Welcome to DirectBeat</h1>
              <h3 style={{ color: 'white' , fontWeight: 'bold' }}>The Decentralized platform for Music Lovers</h3>
              <br /> <br />

              <div className='row'>
                <div className="row-lg-6 mt-5">
                  <img src={mus} className="mus-logo"/>
                  <h2 style={{ color: 'orange' , fontWeight: 'bold'}}>Directly Support Musicians</h2>
                  <p style={{ color: 'white' ,fontSize: '18px'}}>
                    Follow your favorite musicians and <br /> stay up to date in their activities and creations. 
                  </p>
                  <ul style={{ color: 'white' }}>
                    <li>○ Discover new music from upcoming and established artists</li>
                    <li>○ Stream and purchase songs and albums directly from the artist</li>
                    <li>○ Engage with the artist and other fans in a community-driven platform</li>
                  </ul>
                </div>

                <div className="row-lg-6 mt-5">
                  <img src={mus2} className="mus-logo"/>
                  <h2 style={{ color: 'orange' , fontWeight: 'bold' }}>Independent Musicians</h2>
                  <p style={{ color: 'white' , fontSize: '18px'}}>
                    With the power of our blockchain platform,<br /> you can stream our catalog of music from independent musicians
                  </p>
                  <ul style={{ color: 'white' }}>
                    <li>○ Receive exclusive content from your favorite artists</li>
                    <li>○ Attend virtual or in-person concerts and events</li>
                    <li>○ Support artists directly without intermediaries</li>
                  </ul>
                </div>

                <div className="row-lg-6 mt-5">
                  <img src={mus3} className="mus-logo"/>
                  <h2 style={{ color: 'orange' , fontWeight: 'bold' }}>Fair play for musicians</h2>
                  <p style={{ color: 'white' , fontSize: '18px'}}>
                    With a unique currency, fair compensation, <br /> transparent contracts and no intermediaries</p>
                  <ul style={{ color: 'white' }}>
                    <li>○ Musicoin is revolutionizing the creation and distribution of value for musical activity.</li>
                    <li>○ The Musicoin Blockchain ensures each musician receives the most competitive </li>
                    <li>○ industry compensation, instantly and automatically, for each stream of music.</li>
                  </ul>
                </div>


              </div>

            </div>
          </main>
        </div>
      </div>
    </div>
  );
}

export default Welcome;

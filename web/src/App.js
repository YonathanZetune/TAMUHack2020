import React, { Component } from 'react';
import {Map, InfoWindow, Marker, GoogleApiWrapper, HeatMap} from 'google-maps-react';
import Koala from './koala.png'
import Paw from './DogPaw.png'
import Parrot from './parrot.png'
import twitter from './twitter.png'
import kangaroo from './kangaroo.png'
import Help from './Help.png'
import Cred from './Cred'
import axios from 'axios'
import Logo from "./Barelogo.svg"
import './App.css';

const animIm={
  "koala":Koala,
  "Koala":Koala,
  "bird":Parrot,
  "Bird":Parrot,
  "kangaroo":kangaroo,
  "Kangaroo":kangaroo,
  "animal":Paw
}


const gradient = [
  'rgba(0, 255, 255, 0)',
  'rgba(0, 255, 255, 1)',
  'rgba(0, 191, 255, 1)',
  'rgba(0, 127, 255, 1)',
  'rgba(0, 63, 255, 1)',
  'rgba(0, 0, 255, 1)',
  'rgba(0, 0, 223, 1)',
  'rgba(0, 0, 191, 1)',
  'rgba(0, 0, 159, 1)',
  'rgba(0, 0, 127, 1)',
  'rgba(63, 0, 91, 1)',
  'rgba(127, 0, 63, 1)',
  'rgba(191, 0, 31, 1)',
  'rgba(255, 0, 0, 1)'
];


const helpCenters=[
  {
    name:"Canberra Refuge and Animal Shelter",
    address:"Mugga Ln, Symonston ACT 2609, Australia",
    description:"We provide temporary shelter to both humans and animals in need",
    loc:{lat: -35.351389,lng:149.134720}
  },
  {
    name:"Sydney Relief & Rescue",
    address:"5 Bay St, Rockdale NSW 2216, Australia",
    description:"We provide shelter, and necesities to those displaced by fires",
    loc:{lat: -33.953966, lng: 151.139332}
  },
  {
    name:"Anthropocene Rescue",
    address:"National Route 1, Brogo NSW 2550, Australia",
    description:"A state of the oasis for Koalas, Kangaroos, and Wombats",
    loc:{lat: -36.544437, lng: 149.826327}
  },
  {
    name:"Great Barier Relief",
    address:"133 Kurrajong Rd, Narre Warren VIC 3805, Australia",
    description:"Providing the greater Melbourne Area with suplies shelter, and voluntiers",
    loc:{lat: -38.001440,  lng: 145.314314}
  }

]

class App extends Component {

  constructor(props){
    super(props);
    this.getFiresAt=this.getFiresAt.bind(this);
    this.getFires=this.getFires.bind(this);
    this.onMarkerClick=this.onMarkerClick.bind(this);
    this.onInfoWindowClose=this.onInfoWindowClose.bind(this);
    this.onMapClicked=this.onMapClicked.bind(this);
    this.onMouseoverMarker=this.onMouseoverMarker.bind(this);
    this.getTweets=this.getTweets.bind(this);
    // console.log("end",this.getAll([{lat:-37.547991,lon: 149.605046},{lat:-35.884544,lon: 149.573742}]));
    this.state={
      positions: [],
      ready:0,
      animals: [],
      tweets:[],
      activeMarker: {},
      selectedPlace: {},
      showingInfoWindow: false
    }
  }
  componentDidMount(){
    this.getTweets();
    this.getAnimals();
    this.getFires([{lat:-37.547991,lon: 149.605046},{lat:-35.884544,lon: 149.573742},{lat:-33.60119,lon: 116.15500}])
    .then(() => {
      this.setState((state)=>{
        return {ready:1}
      });
    });
    //console.log(this.state.positions)
    
  }

  async getFires(arr){
    return new Promise(resolve => {
      
      for(var i=0;i<arr.length;i++){
        (this.getFiresAt(arr[i].lat,arr[i].lon));
      }

      setTimeout(() => {
        resolve();
      }, 6000);
    })
    
  }

  getAnimals(){
    var url = "https://gentle-reef-37448.herokuapp.com/animals";
    axios.get(url)
    .then((res) => {
      // console.log(res)
      const arr = res.data.animals.map(x => {return {loc: {lat: x.lat, lng: x.lg}, species: x.species, endangered: x.endangered}});
      this.setState((state)=>{
        return {animals: state.animals.concat(arr)}
      })
    })
    .catch((err) => {
      console.log(err);
    });

  }

  getTweets(){
    var url = "https://gentle-reef-37448.herokuapp.com/tweets";
    axios.get(url)
    .then((res) => {
      const arr = res.data.tweets.map(x => {return {loc: {lat: x.lat, lng: x.lg}, name: x.name, content: x.content}});
      this.setState((state)=>{
        return {tweets: state.tweets.concat(arr)}
      })
    })
    .catch((err) => {
      console.log(err);
    });
  }


  async getFiresAt(lat,lon){
    const position=[];
    var url=`https://api.breezometer.com/fires/v1/current-conditions?lat=${lat}&lon=${lon}&key=65cc8d85d7b841259b99df90ff132b35&radius=62&units=imperial`
    return new Promise(resolve => {
      axios.get(url)
      .then((response)=>{
      const fires=response.data.data.fires;
      fires.forEach(element => {
        var lat=element.position.lat;
        var lon=element.position.lon;
        
        if(fires.details){
          console.log(fires.details);
        } else{
          const conf=element.confidence;
          position.push({lat:lat,lng:lon});
          if(conf === "Medium"){
            position.push({lat:lat,lng:lon});
          }
          if(conf === "High"){
            position.push({lat:lat,lng:lon});
            position.push({lat:lat,lng:lon});
          }
        }
        
      }
      );
      console.log(position);
        this.setState((state)=>{
          return {positions: state.positions.concat(position)}
        })
      return position
    });
    });
  }


  onMarkerClick(props, marker, e){
    this.setState({
      activeMarker: marker,
      selectedPlace: props,
      showingInfoWindow: true
    });
  }
  onInfoWindowClose(){
    this.setState({
      activeMarker: null,
      showingInfoWindow: false
    });
  }
  onMapClicked = () => {
    if (this.state.showingInfoWindow)
      this.setState({
        activeMarker: null,
        showingInfoWindow: false
      });
  };
  centerMoved(mapProps,map){
    //handle when the map is moved
  }
  
  onMouseoverMarker(props, marker, e){
    // console.log(e);
    //handle mousing over a Marker
  }
  getImage(str){
    const img=animIm[str];
    if(!img){
      return animIm["animal"];
    } else{
      return img;
    }
  }
      

  render(){
    if (this.state.ready===0){
      return <div className="fill"><h1>NotiFire</h1><img src={Logo}/><h3>Loading</h3></div>
    }
    return (
      <div className="App">
        <Map google={this.props.google}
          zoom={7} 
          initialCenter={{
            lat: -36.520900,
            lng: 146.743292
          }}
          className={"map"}
          onDragend={this.centerMoved}
        >
        <HeatMap
            gradient={gradient}
            opacity={0.3}
            positions={this.state.positions}
            radius={20}
          />
          {this.state.animals.map((animal,i)=>{
            {/* console.log(animal); */}
            return (<Marker onClick={this.onMarkerClick} 
                name={animal.species} 
                location={`${animal.loc.lat},${animal.loc.lng}`}
                position={animal.loc}
                type={"animal"}
                key={i}
                icon={{
                    url: this.getImage(animal.species),
                    scaledSize: {width:40,height:40}}
                    }/>
                )
          })}
          {this.state.tweets.map((tweet,i)=>{
            {/* console.log(tweet); */}
            return (<Marker onClick={this.onMarkerClick} 
                name={tweet.name}
                location={`${tweet.loc.lat},${tweet.loc.lng}`}
                position={tweet.loc}
                content={tweet.content}
                type={"tweet"}
                key={`tweet${i}`}
                icon={{
                    url: twitter,
                    scaledSize: {width:30,height:30}}
                    }/>
                )
          })}
          {helpCenters.map((center,i)=>{
            {/* console.log(tweet); */}
            return (<Marker onClick={this.onMarkerClick} 
                name={center.name}
                location={`${center.loc.lat},${center.loc.lng}`}
                address={center.address}
                position={center.loc}
                content={center.description}
                type={"help"}
                key={`Help${i}`}
                icon={{
                    url: Help,
                    scaledSize: {width:30,height:30}}
                    }/>
                )
          })}
          <InfoWindow Style={{maxWidth:"100px"}}
                      marker={this.state.activeMarker}
                      visible={this.state.showingInfoWindow}>
                        <div>
                          <h1>{this.state.selectedPlace.name}</h1>
                          { this.state.selectedPlace.type=="tweet" ? <p style={{maxWidth:"300px"}}>{this.state.selectedPlace.content}</p>: ""}
                          { this.state.selectedPlace.type=="help" ? <><h3>{this.state.selectedPlace.address}</h3><p style={{maxWidth:"300px", margin:"auto"}}>{this.state.selectedPlace.content}</p></> : ""}
                          <h5>{this.state.selectedPlace.location}</h5>
                        </div>
                    </InfoWindow>
        </Map>
        {this.state.animals.forEach((animal)=>{
            {/* console.log(<Marker onClick={this.onMarkerClick} name={animal.species} position={animal.loc}/>); */}
            return <h1>Hi</h1>
          })}
      </div>
    );
  }
  
}

export default GoogleApiWrapper({
  apiKey: (Cred.MapsAPI),
  libraries: ['visualization']
})(App);

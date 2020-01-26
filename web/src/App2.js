import React, { Component } from 'react';
import {Map, InfoWindow, Marker, GoogleApiWrapper, Circle, HeatMap} from 'google-maps-react';
import Koala from './koala.png'
import Cred from './Cred'
import axios from 'axios'
import './App.css';


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


class App extends Component {

  constructor(props){
    super(props);
    this.fetchFires=this.fetchFires.bind(this);
    this.getAll=this.getAll.bind(this);
    // console.log("end",this.getAll([{lat:-37.547991,lon: 149.605046},{lat:-35.884544,lon: 149.573742}]));
    this.state={
      positions: [],
      ready:0
    }
  }
  componentDidMount(){
    this.getAll([{lat:-37.547991,lon: 149.605046},{lat:-35.884544,lon: 149.573742}]);
    
    this.setState((state)=>{
      return {ready:1}
    })
  }


  onMarkerClick(){
    console.log("clicked")
  }
  onInfoWindowClose(){
    console.log("Closed")
  }
  centerMoved(mapProps,map){
    //handle when the map is moved
  }
  
  onMouseoverMarker(props, marker, e){
    //handle mousing over a Marker
  }

  async getAll(arr){
    this.fetchFires(arr[i].lat,arr[i].lon)
    for(var i=0;i<arr.length;i++){
      this.fetchFires(arr[i].lat,arr[i].lon).then(()=>{
        console.log("i",i);
        if(i+1==arr.length){
          console.log("done");
        }
      });
    }
    console.log("out");
    return;
  }
  async fetchFires(lat,lon){
    var url=`https://api.breezometer.com/fires/v1/current-conditions?lat=${lat}&lon=${lon}&key=65cc8d85d7b841259b99df90ff132b35&radius=62&units=imperial`
    var position=[];
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
        this.setState((state)=>{
          return {positions: state.positions.concat(position)}
        })
      });
      
    })
    .catch((error)=>{
      console.log(error)
    })
    .finally(()=>{
      console.log(position);
      return new Promise(resolve => {
        console.log("fetched");
        resolve();
      });
      
    })
    
  }
  render(){
    if (this.state.ready===0){
      return <div>Loading...</div>
    }
    return (
      <div className="App">
        <Map google={this.props.google}
          zoom={7} 
          initialCenter={{
            lat: -33.239928,
            lng: 150.406609
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
          <Marker onClick={this.onMarkerClick}
                  name={'Current location'} 
                  icon={{
                    url: Koala,
                    scaledSize: {width:30,height:30}}
                    }/>

          {/* <Circle radius={1200}
            Center={{lat:-33.464038,lng:150.777327}}/> */}
   
          {/* <InfoWindow onClose={this.onInfoWindowClose}>
              <div>
                {/* <h1>{state.selectedPlace.name}</h1> 
              </div>
          </InfoWindow> */}
        </Map>
      </div>
    );
  }
  
}

export default GoogleApiWrapper({
  apiKey: (Cred.MapsAPI),
  libraries: ['visualization']
})(App);

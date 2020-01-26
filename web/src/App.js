import React, { Component } from 'react';
import {Map, InfoWindow, Marker, GoogleApiWrapper, Circle} from 'google-maps-react';
import Koala from './koala.png'
import Cred from './Cred'
import './App.css';



class App extends Component {
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
  render(){
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
   
          <Marker onClick={this.onMarkerClick}
                  name={'Current location'} 
                  icon={Koala}/>
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
  apiKey: (Cred.MapsAPI)
})(App);

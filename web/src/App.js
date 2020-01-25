import React from 'react';
import {Map, InfoWindow, Marker, GoogleApiWrapper} from 'google-maps-react';
import Cred from './Credentials'
import './App.css';

function onMarkerClick(){
  console.log("clicked")
}
function onInfoWindowClose(){
  console.log("Closed")
}

function App(props) {
  return (
    <div className="App">
      <Map google={props.google} zoom={14}>
 
        <Marker onClick={onMarkerClick}
                name={'Current location'} />
 
        <InfoWindow onClose={onInfoWindowClose}>
            <div>
              {/* <h1>{state.selectedPlace.name}</h1> */}
            </div>
        </InfoWindow>
      </Map>
    </div>
  );
}

export default GoogleApiWrapper({
  apiKey: (Cred.MapsAPI)
})(App);

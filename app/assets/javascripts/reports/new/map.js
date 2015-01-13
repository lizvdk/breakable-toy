function drawNewReportMap(){
  var geocoder = new google.maps.Geocoder();

  function geocodePosition(pos) {
    geocoder.geocode({
      latLng: pos
    }, function(responses) {
      if (responses && responses.length > 0) {
        updateMarkerAddress(responses[0].formatted_address);
      } else {
        updateMarkerAddress('Cannot determine address at this location.');
      }
    });
  }

  function updateMarkerPosition(latLng) {
    document.getElementById('report_latitude').value =
    latLng.lat()
    document.getElementById('report_longitude').value =
    latLng.lng()
  }

  function updateMarkerAddress(str) {
    document.getElementById('report_address').value = str;
  }

  function initialize() {
    var latLng = new google.maps.LatLng(42.3603, -71.058);
    var map = new google.maps.Map(document.getElementById('map'), {
      zoom: 8,
      center: latLng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    });
    var marker = new google.maps.Marker({
      position: latLng,
      title: 'Point A',
      map: map,
      draggable: true
    });

    // Update current position info.
    updateMarkerPosition(latLng);
    geocodePosition(latLng);

    // Add dragging event listeners.
    google.maps.event.addListener(marker, 'dragstart', function() {
      updateMarkerAddress('Dragging...');
    });

    google.maps.event.addListener(marker, 'drag', function() {
      updateMarkerPosition(marker.getPosition());
    });

    google.maps.event.addListener(marker, 'dragend', function() {
      geocodePosition(marker.getPosition());
    });
  }

  // Onload handler to fire off the app.
  google.maps.event.addDomListener(window, 'load', initialize);
};
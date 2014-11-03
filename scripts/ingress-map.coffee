# Description:
#   Interacts with the Google Maps API and displays an Ingress map of the area in the query.
#
# Commands:
#   hubot ingressmap <query> - Returns a map view of the area returned by `query`.

module.exports = (robot) ->

  robot.respond /ingressmap (.*)/i, (msg) ->
    query = msg.match[1]
    key   = process.env.HUBOT_GOOGLE_API_KEY

    if !key
      msg.send "Please enter your Google API key in the environment variable HUBOT_GOOGLE_API_KEY."

    geocodeMe msg, query, (text) ->
      #msg.reply text
      msg.reply "https://www.ingress.com/intel?ll=" + text + "&z=12"

geocodeMe = (msg, query, cb) ->
  msg.http("https://maps.googleapis.com/maps/api/geocode/json")
    .header('User-Agent', 'Hubot Geocode Location Engine')
    .query({
      address: query
      sensor: false
    })
    .get() (err, res, body) ->
      response = JSON.parse(body)
      return cb "No idea. Tried using a map? https://maps.google.com/" unless response.results?.length

      location = response.results[0].geometry.location.lat + "," + response.results[0].geometry.location.lng
      #cb "That's somewhere around " + location + " - https://maps.google.com/maps?q=" + location
      cb location

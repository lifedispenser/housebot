jsdom = require 'jsdom'
jquery = 'http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js'

module.exports = (robot) ->

  robot.hear /(realtor.com.+)/i, (msg) ->
    console.log("http://www." + msg.match[1]);
    robot.http("http://www." + msg.match[1])
      .get() (err, res, body) ->
        jsdom.env body, [jquery], (errors, window) ->
          data = {
            url: window.location.href
            address: window.$('[itemprop=streetAddress]').eq(0).text()
            city: window.$('[itemprop=addressLocality]').eq(0).text()
            state: window.$('[itemprop=addressRegion]').eq(0).text()
            zip: window.$('[itemprop=postalCode]').eq(0).text()
            price: window.$('[itemprop=price]').eq(0).text()
            image: window.$('[itemprop=image]').eq(0).attr("src")
            bed: window.$('span:contains(Beds) +').eq(0).text()
            bath: window.$('span:contains(Baths) +').eq(0).text()
          }
          msg.send "Address: #{data.address}, #{data.city}, #{data.state} \r\n #{data.bed}, #{data.bath} \r\n Price: #{data.price} \r\n #{data.image}"
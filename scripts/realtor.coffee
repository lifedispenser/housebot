cheerio = require('cheerio')

module.exports = (robot) ->

  robot.hear /(realtor.com.+)/i, (msg) ->
    robot.http("http://www." + msg.match[1])
      .get() (err, res, body) ->
        $ = cheerio.load(body)
        data = {
          address: $('[itemprop=streetAddress]').eq(0).text()
          city: $('[itemprop=addressLocality]').eq(0).text()
          state: $('[itemprop=addressRegion]').eq(0).text()
          zip: $('[itemprop=postalCode]').eq(0).text()
          price: $('[itemprop=price]').eq(0).text()
          image: $('[itemprop=image]').eq(0).attr("src")
          bed: $('span:contains(Beds) +').eq(0).text()
          bath: $('span:contains(Baths) +').eq(0).text()
        }
        msg.send "Address: #{data.address}, #{data.city}, #{data.state} \r\n #{data.bed}, #{data.bath} \r\n Price: #{data.price} \r\n #{data.image}"

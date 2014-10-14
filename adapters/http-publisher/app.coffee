log4js = require 'log4js'
log = log4js.getLogger 'herald-http-publisher'

redis = require 'redis'
express = require 'express'
bodyParser = require 'body-parser'

config = require './config'

sub = redis.createClient config.redis.port, config.redis.host
pub = redis.createClient config.redis.port, config.redis.host

onError = (err) ->
	if err.message.indexOf 'ECONNREFUSED' > 0
		log.warn "can't reach redis", err
	else
		log.err err.message

sub.on 'error', onError
pub.on 'error', onError

sub.on 'subscribe', (channel, count) ->
	log.info 'subscribed', channel, count

sub.on 'message', (channel, message) ->
	log.info 'announcing: ', message

sub.subscribe "announce"

app = express()
app.use bodyParser.json()

app.post '/', (req, res) ->
	log.info 'publishing: ', req.body
	pub.publish 'announce', JSON.stringify req.body
	res.end()

app.get '/', (req, res) ->
	res.send 'see https://github.com/shackspace/herald for all the docs.'
	res.end()

server = app.listen config.port, ->
	log.info 'Listening on port %d', server.address().port

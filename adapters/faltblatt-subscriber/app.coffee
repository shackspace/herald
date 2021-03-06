log4js = require 'log4js'
log = log4js.getLogger 'herald-faltblatt-subscriber'

redis = require 'redis'
request = require 'request'

config = require './config'

sub = redis.createClient config.redis.port, config.redis.host

onError = (err) ->
	if err.message.indexOf 'ECONNREFUSED' > 0
		log.warn "can't reach redis", err
	else
		log.err err.message

sub.on 'error', onError

sub.on 'subscribe', (channel, count) ->
	log.info 'subscribed', channel, count

sub.on 'message', (channel, message) ->
	log.info 'got message: ', message
	parsedMessage = JSON.parse message
	log.info 'sending to flap display: ', parsedMessage
	request config.flapurl + parsedMessage.content

sub.subscribe "announce"
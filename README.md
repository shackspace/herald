# announce


### magical announce networking inside the hackerspace

## Things and Names
- Project HERALD?
- publisher: sender of the message, wants a message to be announced
- subscriber: display / announcement device, willing to announce messages

## Requirements and Stuff
- Many devices / displays to output fun or important messages to (subscriber)
- Many services displaying messages on these devices (publisher)
- Need a general method to announce messages via all or some subscribers
- Assume different levels and types of messages
- publishers does not need to know subscribers and vice versa
- hide implementation details and protocols of subscribers
- standalone services already exist for many devices, provide adapters for those
- subscribers are able to choose which messages to announce, provide information to filter (publisher, level, location)
- provide easy method to publish for better adaption

## Architecture Draft

### Technologies

- redis pub/sub as main communication channel
- websocket adapters into redis (see shack-pubsub), allows browser subscribers
- simple HTTP request to publish a single message (no subscribing over http)

### Message Format
JSON, yeah!

```
{
	message: String,
	[publisher OR source: String (e.g. 'fortune', 'shackles'),]
	[priority: Number (0, 1, 2, 3) OR String ('low', 'normal', 'high'),]
	[location: String,]
	[subscriber: Sting] // magical query syntax overkill here?
}
```
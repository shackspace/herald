# shackspace herald


### magical announce networking inside the hackerspace

## Things and Names
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
	content: String,
	[from: String (e.g. 'fortune', 'shackles'),]
	[priority: String ('low', 'normal', 'high'),]
	[location: String,]
	[to: Sting] // magical query syntax overkill here?
	[data: Object (raw data to build custom messages)]
}
```

### Channel Patterns

Redis pubsub supports channel pattern subscription, but without high load, clients can filter messages themselves, no need for clever pattern syntax.

### Use Cases

#### login / online announce

publishers: shackles
subscribers: goebbels, porthos, faltblatt, clock

```
{
	content: 'Say hello to rash.',
	from: 'shackles',
	priority: 'high'
	data:
		username: 'rash'
		action: 'login'
}
```

#### fortunes

publishers: fortune
subscribers: porthos, faltblatt

```
{
	content: 'Q:	Why did the tachyon cross the road?\nA:	Because it was on the other side.',
	from: 'fortune',
	priority: 'low'
}
```

## Identified Problems

- length restriction on message content:
	- porthos and faltblatt have a low limited number of visible characters
	- could be solved by scrolling or paging (porthos already does this)
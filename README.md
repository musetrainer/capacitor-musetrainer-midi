# capacitor-musetrainer-midi

Capacitor MIDI plugin by MuseTrainer

## Install

```bash
npm install capacitor-musetrainer-midi
npx cap sync
```

## API

<docgen-index>

* [`addListener('deviceChange' | 'commandSend' | 'connectError', ...)`](#addlistenerdevicechange--commandsend--connecterror)
* [`listDevices()`](#listdevices)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### addListener('deviceChange' | 'commandSend' | 'connectError', ...)

```typescript
addListener(eventName: 'deviceChange' | 'commandSend' | 'connectError', listenerFunc: (...args: any[]) => void) => PluginListenerHandle
```

| Param              | Type                                                           |
| ------------------ | -------------------------------------------------------------- |
| **`eventName`**    | <code>'deviceChange' \| 'commandSend' \| 'connectError'</code> |
| **`listenerFunc`** | <code>(...args: any[]) =&gt; void</code>                       |

**Returns:** <code><a href="#pluginlistenerhandle">PluginListenerHandle</a></code>

--------------------


### listDevices()

```typescript
listDevices() => Promise<{ devices: any[]; }>
```

**Returns:** <code>Promise&lt;{ devices: any[]; }&gt;</code>

--------------------


### Interfaces


#### PluginListenerHandle

| Prop         | Type                                      |
| ------------ | ----------------------------------------- |
| **`remove`** | <code>() =&gt; Promise&lt;void&gt;</code> |

</docgen-api>

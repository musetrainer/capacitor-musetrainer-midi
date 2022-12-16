[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/musetrainer/capacitor-musetrainer-midi/blob/master/LICENSE)
[![version](https://img.shields.io/npm/v/capacitor-musetrainer-midi/latest.svg)](https://www.npmjs.com/package/capacitor-musetrainer-midi)
  
# capacitor-musetrainer-midi

Capacitor MIDI plugin by MuseTrainer.

Only support iOS for now.

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

import { BusinessError } from '@ohos.base'
import hiAppEvent from '@ohos.hiviewdfx.hiAppEvent'
import hilog from '@ohos.hilog'

import { EventTriggerType, EventPayloadType }  from '../utils/interface'

export function writeLog(eventTrigger: EventTriggerType) {
  let eventInfo: hiAppEvent.AppEventInfo = {
    // 事件领域定义
    domain: eventTrigger.type,
    // 事件名称定义
    name: eventTrigger.trigger,
    // 事件类型定义
    eventType: hiAppEvent.EventType.BEHAVIOR,
    // 事件参数定义
    params: ({
      key: eventTrigger.key,
      value: eventTrigger.value,
    } as EventPayloadType),
  };
  hiAppEvent.write(eventInfo).then(() => {
    hilog.info(0x0000, 'testTag', `HiAppEvent success to write event`)
  }).catch((err: BusinessError) => {
    hilog.error(0x0000, 'testTag', `HiAppEvent err.code: ${err.code}, err.message: ${err.message}`)
  });
}
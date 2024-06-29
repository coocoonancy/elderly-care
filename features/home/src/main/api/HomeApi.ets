import { request } from '@hm/basic/Index'
import { MessageCountData } from '../viewmodel/HomeModel'

export function getMessageCountApi() {
  return request<MessageCountData>({ url: '/employee/message/statisticsUnreadByType' })
}

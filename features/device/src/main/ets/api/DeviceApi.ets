import { request } from '@hm/basic/Index'
import { UnBindProductItem } from '../pages/BindDevicePage'

export function getUnbindDeviceListApi() {
  return request<UnBindProductItem[]>({ url: '/employee/iot/deviceTree' })
}
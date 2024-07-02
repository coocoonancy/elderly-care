import { AxiosProgressEvent, FormData } from '@ohos/axios';
import { request } from '../utils/Request'

export function uploadApi(data: FormData, context: Context, onUploadProgress?: (progressEvent: AxiosProgressEvent) => void) {
  return request<string, FormData>({
    url: '/common/upload',
    method: 'post',
    headers: { 'Content-Type': 'multipart/form-data' },
    data,
    // 比传
    context,
    // onUploadProgress
  })
}
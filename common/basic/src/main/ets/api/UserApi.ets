import { request } from '../utils/Request'
import { LoginParams, UserData, UpdateUserParams } from '../viewmodel/UserModel'

/**
 * 登录 api
 * @param data
 * @returns
 */
export function LoginApi(data: LoginParams) {
  return request<string, LoginParams>({ url: '/employee/login', method: 'post', data })
}

/**
 * 获取登录用户信息
 * @returns
 */
export function getUserApi() {
  return request<UserData>({ url: '/employee/user' })
}

/**
 * 更新用户头像
 * @param avatar
 * @returns
 */
export function updateUserPhotoApi(avatar: string) {
  return request<null, UpdateUserParams>({
    url: '/employee/user/updateAvatar', method: 'put', params: {
      avatar
    }
  })
}
import { Log } from '@abner/log';

import axios, {
  AxiosError,
  AxiosHeaders,
  AxiosProgressEvent,
  AxiosResponse,
  InternalAxiosRequestConfig,
  Method,
  RawAxiosRequestHeaders
} from '@ohos/axios';
import { UserStore } from './Auth';
import { router } from '@kit.ArkUI';
import { RouterConfig } from '../constants/RouterConfig';

// 1. 创建请求的自定义实例
const instance = axios.create({
  // 后台请求基础地址
  baseURL: 'https://zhyl-harmony.itheima.net',
  // 请求超时时间
  timeout: 5000
});

//2. 给实例添加拦截器
// 添加请求拦截器=》先执行请求拦截器
instance.interceptors.request.use(async (config: InternalAxiosRequestConfig) => {
  Log.warn('开始请求了')
  // 对请求数据做点什么
  Log.info(`1-请求配置${config.method!}-${config.url}：${JSON.stringify(config.params || config.data)}`)
  // 演示使用
  // config.headers.Authorization = 'eyJhbGciOiJIUzI1NiJ9.eyJjdXJyZW50VXNlciI6IntcInVzZXJuYW1lXCI6XCJobHpnQHFxLmNvbVwiLFwicGFzc3dvcmRcIjpcIlwiLFwibmlja05hbWVcIjpcIuaKpOeQhue7hOS4u-euoVwiLFwiZW1haWxcIjpcImhsemdAcXEuY29tXCIsXCJyZWFsTmFtZVwiOlwi5oqk55CG57uE5Li7566hXCIsXCJtb2JpbGVcIjpcIlwiLFwic2V4XCI6XCJcIixcImRlcHROb1wiOlwiMTAwMDAxMDA1MDAwMDAwXCIsXCJwb3N0Tm9cIjpcIjEwMDAwMTAwNTAwMjAwMFwiLFwiaWRcIjoxNjY4NTIyMjgwODUxOTUxNjE3LFwiY3JlYXRlVGltZVwiOjE2OTU3MTAwOTcwMDAsXCJ1cGRhdGVUaW1lXCI6MTY5NTcxMDA5NzAwMCxcImNyZWF0ZUJ5XCI6MTY3MTQwMzI1NjUxOTA3ODEzOH0iLCJleHAiOjE0NjY0ODUzMzkyfQ.AwoGeu-mp0QSSsQnDOhQluAPdbFM7Ygll86fk6l3DIA'
  // 对请求数据做点什么
  // 演示使用
  // config.headers.Authorization = 'eyJhbGciOiJIUzI1NiJ9.eyJjdXJyZW50VXNlciI6IntcInVzZXJuYW1lXCI6XCJobHpnQHFxLmNvbVwiLFwicGFzc3dvcmRcIjpcIlwiLFwibmlja05hbWVcIjpcIuaKpOeQhue7hOS4u-euoVwiLFwiZW1haWxcIjpcImhsemdAcXEuY29tXCIsXCJyZWFsTmFtZVwiOlwi5oqk55CG57uE5Li7566hXCIsXCJtb2JpbGVcIjpcIlwiLFwic2V4XCI6XCJcIixcImRlcHROb1wiOlwiMTAwMDAxMDA1MDAwMDAwXCIsXCJwb3N0Tm9cIjpcIjEwMDAwMTAwNTAwMjAwMFwiLFwiaWRcIjoxNjY4NTIyMjgwODUxOTUxNjE3LFwiY3JlYXRlVGltZVwiOjE2OTU3MTAwOTcwMDAsXCJ1cGRhdGVUaW1lXCI6MTY5NTcxMDA5NzAwMCxcImNyZWF0ZUJ5XCI6MTY3MTQwMzI1NjUxOTA3ODEzOH0iLCJleHAiOjE0NjY0ODUzMzkyfQ.AwoGeu-mp0QSSsQnDOhQluAPdbFM7Ygll86fk6l3DIA'
  // config.headers.Authorization = 'eyJhbGciOiJIUzI1NiJ9.eyJjdXJyZW50VXNlciI6IntcInVzZXJuYW1lXCI6XCJobGJ6QHFxLmNvbVwiLFwicGFzc3dvcmRcIjpcIlwiLFwibmlja05hbWVcIjpcIuaKpOeQhumDqOmDqOmVv1wiLFwiZW1haWxcIjpcImhsYnpAcXEuY29tXCIsXCJyZWFsTmFtZVwiOlwi5oqk55CG6YOo6YOo6ZW_XCIsXCJtb2JpbGVcIjpcIlwiLFwic2V4XCI6XCJcIixcImRlcHROb1wiOlwiMTAwMDAxMDA1MDAwMDAwXCIsXCJwb3N0Tm9cIjpcIjEwMDAwMTAwNTAwMTAwMFwiLFwiaWRcIjoxNjcxNDAzMjU2NTE5MDc4MTU2LFwiY3JlYXRlVGltZVwiOjE2OTU3MTAwNzYwMDAsXCJ1cGRhdGVUaW1lXCI6MTY5NTcxMDA3NjAwMCxcImNyZWF0ZUJ5XCI6MTY3MTQwMzI1NjUxOTA3ODEzOH0iLCJleHAiOjE0Njc1MzEyNzU0fQ.n3EJBhfA1YIJ1tyASI4ruNbmDutY_xHAvdwPClizfpo'
  config.headers.Authorization =
    'eyJhbGciOiJIUzI1NiJ9.eyJjdXJyZW50VXNlciI6IntcInVzZXJuYW1lXCI6XCIzNTQyMzQ4NEBxcS5jb21cIixcInBhc3N3b3JkXCI6XCJcIixcIm5pY2tOYW1lXCI6XCLmiqTnkIblkZgxXCIsXCJlbWFpbFwiOlwiMzU0MjM0ODRAcXEuY29tXCIsXCJyZWFsTmFtZVwiOlwi5oqk55CG5ZGYMVwiLFwibW9iaWxlXCI6XCIxODIxMTAyMTg5NlwiLFwic2V4XCI6XCIwXCIsXCJkZXB0Tm9cIjpcIjEwMDAwMTAwNTAwMDAwMFwiLFwicG9zdE5vXCI6XCIxMDAwMDEwMDUwMDMwMDBcIixcImRhdGFTdGF0ZVwiOlwiMFwiLFwiYXZhdGFyXCI6XCJodHRwczovL3lqeS1vc3MtdmlkZW9zLm9zcy1hY2NlbGVyYXRlLmFsaXl1bmNzLmNvbS9ncnp4aHouanBnXCIsXCJpZFwiOjE2NzE0MDMyNTY1MTkwNzgyNzUsXCJjcmVhdGVUaW1lXCI6MTcxNTU2ODM5MDAwMCxcInVwZGF0ZVRpbWVcIjoxNzE1NTY4MzkwMDAwLFwiY3JlYXRlQnlcIjoxNjcxNDAzMjU2NTE5MDc4MTM4fSIsImV4cCI6MTQ2NzU2NTk0Nzd9.8PrMKBNrVVCfcI4DgICxp6oBQGqy46m3oglFQCiKtzw'
  // 统一添加 token
  const store = await UserStore.getUser()
  Log.info(store.token)
  if (store.token) {
    config.headers.Authorization = store.token
  }
  return config;
}, (error: AxiosError) => {
  // 对请求错误做些什么
  return Promise.reject(error);
});


// 添加响应拦截器=》请求响应之后执行
instance.interceptors.response.use((response: AxiosResponse) => {
  // 对响应数据做点什么
  if (response.data?.code && response.data.code !== 200) {
    AlertDialog.show({
      message: response.data?.msg
    })
    Log.error('3-code请求错误：' + JSON.stringify(response.data))
    return Promise.reject(response.data)
  }
  Log.warn('2-请求成功结果：' + JSON.stringify(response.data))
  // 简化数据返回
  return response.data?.data
}, (error: AxiosError) => {
  AlertDialog.show({
    message: error.response?.status + '：' + error.message
  })
  Log.error('3-http请求错误：' + JSON.stringify(error))

  // 处理 401=》 token 失效，重新登录
  if (error.response?.status === 401) {
    UserStore.delUser()
    router.replaceUrl({
      url: RouterConfig.LOGIN_URL
    })
  }

  // 对响应错误做点什么
  return Promise.reject(error);
});

interface RequestParams<T> {
  url: string
  method?: Method
  params?: T
  data?: T
  headers?: RawAxiosRequestHeaders | AxiosHeaders
  context?: Context
  onUploadProgress?: (progressEvent: AxiosProgressEvent) => void
}

export function request<DataModel = null, DataParams = null>(requestParams: RequestParams<DataParams>): Promise<DataModel> {
  return instance<null, DataModel>(requestParams)
}
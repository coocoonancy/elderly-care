import { ProductNameList } from '../constants/DeviceData'

interface HomeTabCtrl {
  homeController: TabsController | null
}

// 导出一个对象=》全局存储入口层的 tab 控制器实例=》内存
export const homeTabCtrl: HomeTabCtrl = {
  homeController: null
}


// 获取产品中英文映射关系
export function getDeviceMap(en: string) {
  return ProductNameList.find(item => item.en === en)
}
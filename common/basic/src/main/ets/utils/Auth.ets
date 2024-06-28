import { preferences } from '@kit.ArkData'

export class User {
  token: string = ''
}


class userStore {
  key = 'user-store'

  getStore() {
    return preferences.getPreferences(getContext(this), { name: 'UserStore' })
  }

  async getUser() {
    const store = await this.getStore()
    const data = await store.get(this.key, '{}') as string;
    return JSON.parse(data) as User
  }

  async setUser(user: User) {
    const store = await this.getStore()
    await store.put(this.key, JSON.stringify(user))
    await store.flush()
  }

  async delUer() {
    const store = await this.getStore()
    await store.delete(this.key)
    await store.flush()
  }
}

// 导出单例
export const UserStore = new userStore()


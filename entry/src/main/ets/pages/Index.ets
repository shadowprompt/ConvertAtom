/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 ("the License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { Introduce } from '../views/introduce';
import { Convert } from '../views/convert';
import { Route, ROUTES } from '../constants/Constants';
import { genTabBars, TabBarItemType } from '../utils/index'

@Entry
@Component
struct Index {
  @Provide navPageInfos: NavPathStack = new NavPathStack();
  @State activeTabIndex: number = 0;

  go(to: string | undefined) {
    if (!to) {
      return;
    }
    this.navPageInfos.pushPath({ name: to });
  }

  isActive(index: number): boolean {
    return this.activeTabIndex === index;
  }

  onActiveTabChange(index: number) {
    this.activeTabIndex = index;
  }

  @Builder
  NavPageMap(name: string) {
    if (name === 'introduce') {
      Introduce();
    }
  }

  @Builder
  TabBarBuilder(tabBar: TabBarItemType, index: number) {
    Column() {
      Text(tabBar.text)
        .fontSize(10)
        .fontWeight(500)
        .fontColor(this.isActive(index) ? '#D0092D' : Color.Black)
        .opacity(this.isActive(index) ? 1 : 0.4)
    }
  }

  build() {
    Navigation(this.navPageInfos) {
      Flex({ direction: FlexDirection.Column }) {
        Text($r('app.string.title'))
          .fontWeight(FontWeight.Bold)
          .fontSize(24)
          .fontColor('#E6000000')
          .width('100%')



        Tabs({ barPosition: BarPosition.End }) {
          // DocsDot
          ForEach(genTabBars(), (tabBar: TabBarItemType, index) => {
            TabContent() {
              if (index === 0) {
                Introduce()
              } else if (index === 1) {
                Convert()
              }
            }
            .margin({
              top: 16,
              bottom: 16
            })
            .tabBar(this.TabBarBuilder(tabBar, index))
          }, (tabBar: TabBarItemType) => JSON.stringify(tabBar.text))
          // DocsDot
        }
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        // DocsCode 1
        .onChange((index: number) => this.onActiveTabChange(index))
      }
      .width('100%')
      .height('100%')
      .padding(16)
    }
    .hideToolBar(true)
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
    .navDestination(this.NavPageMap)
  }
}
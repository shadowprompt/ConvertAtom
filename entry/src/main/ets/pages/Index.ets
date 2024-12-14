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
import { Discovery } from '../views/discovery';
import { More } from '../views/more';
import { COLOR_ACTIVE, COLOR_BLUR, TAB_BARS } from '../constants/Constants';
import { TabBarItemType } from '../utils/interface'

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
      Image(this.isActive(index) ? tabBar.iconActive : tabBar.icon)
        .width(24)
        .height(24)
        .margin({ bottom: 0 })
      Text(tabBar.text)
        .fontSize(10)
        .fontWeight(600)
        .fontColor(this.isActive(index) ? COLOR_ACTIVE : COLOR_BLUR)
    }
  }

  build() {
    Navigation(this.navPageInfos) {
      Flex({ direction: FlexDirection.Column }) {
        Row() {
          Text($r('app.string.title'))
            .fontWeight(FontWeight.Bold)
            .fontSize(24)
            .fontColor('#E6000000')
            .width('100%')
        }
        .padding(16)



        Tabs({ barPosition: BarPosition.End }) {
          // DocsDot
          ForEach(TAB_BARS, (tabBar: TabBarItemType, index: number) => {
            TabContent() {
              Column() {
                if (tabBar.type === 'index') {
                  Introduce()
                } else if (tabBar.type === 'convert') {
                  Convert()
                } else if (tabBar.type === 'discovery'){
                  Discovery()
                } else if (tabBar.type === 'more'){
                  More()
                }
              }
              .margin({
               bottom: 16
              })
              .width('100%')
              .height('100%')
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
    }
    .hideToolBar(true)
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
    .navDestination(this.NavPageMap)
  }
}
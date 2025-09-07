print("准备就绪")
--初始化所有准备好的类别名
require("InitClass")
--初始化道具表信息
require("ItemData")
--玩家信息
--1.从本地获取 本地存储有几种方式：PlayerPrefs 和 Json 或者 二进制
--2.网络游戏 从服务器获取

--初始化玩家数据
require("PlayerData")
require("ShopItemData")
ShopItemData.InitData()
PlayerData:Init()
ShopItemData:Init()

--之后的逻辑可以直接使用
require("BasePanel")
require("MainPanel")
require("BagPanel")
require("ShopPanel")
require("TipsPanel")
require("ItemGrid")
require("ItemDes")  -- 加载道具描述面板
require("ItemManager")

-- 只初始化主面板，ItemDes 会在第一次使用时延迟初始化
MainPanel:Init("MainPanel")

--枚举
GridType = {
    bag = "bag";
    shop = "shop"
}

print("初始化完成")
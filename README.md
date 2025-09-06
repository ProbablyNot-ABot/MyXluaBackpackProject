# MyXluaBackpackProject
简单的基于的xlua背包demo，实现了通过AssetBundle加载资源，通过
Lua 背包系统 - Unity Lua Inventory System
一个基于 Unity + Lua 实现的完整背包商店系统，使用 xLua 框架进行热更新，支持道具分类管理、商店购买、热更新等核心功能，适用于 Unity 游戏项目的背包模块快速集成。


image


image


image


image
🌟 功能特性
🎒 背包系统
多标签分类：按「装备」「道具」「宝石」实现分页显示，支持快速切换
动态格子布局：自动适配道具数量，支持滚动视图加载，避免界面拥挤
道具详情预览：点击道具格子弹出层显示完整信息（名称、图标、描述、属性等）
数量管理机制：支持道具堆叠（同类型道具合并显示）、数量增减与上限控制
🏪 商店系统
商品分类展示：与背包分类联动，按道具类型筛选可购买商品
灵活购买流程：支持自定义购买数量，实时计算总价，防止资源不足
动态价格体系：道具价格在配置文件中定义，支持后续扩展折扣逻辑
实时库存同步：购买成功后即时更新背包库存，无需刷新界面
⚡ 技术特色
xLua 热更新：核心逻辑（背包管理、商店交互）均用 Lua 编写，支持运行时热重载，无需重新打包
Lua 面向对象：基于 Object.lua 实现完整 OOP 架构，模块解耦，便于维护
AB 包资源管理：UI 预制体、图片、配置等资源通过 AB 包动态加载，优化资源占用
UI 组件化设计：基于 BasePanel.lua 封装可复用 UI 面板，新增功能无需重复开发基础逻辑
🛠 技术栈
类别	技术 / 工具	版本要求	说明
游戏引擎	Unity	2022.3+	项目开发与运行基础
脚本语言	Lua	5.1	编写业务逻辑（热更新核心）
热更新框架	xLua	2.1.15+	实现 C# 与 Lua 交互、热更新
UI 系统	Unity UGUI	内置版本	搭建背包、商店界面
数据格式	JSON	无特定版本	存储道具配置、玩家数据
资源管理	AB 包（AssetBundle）	Unity 内置功能	资源打包与动态加载
📦 项目结构
text
Assets/
├── LuaScripts/           # Lua 业务逻辑核心目录
│   ├── Main.lua          # 程序入口（初始化系统、加载配置）
│   ├── Object.lua        # Lua 面向对象基类（封装继承、多态支持）
│   ├── BasePanel.lua     # UI 面板基类（封装显示/隐藏、事件绑定）
│   ├── BagPanel.lua      # 背包面板逻辑（分类切换、道具渲染）
│   ├── ShopPanel.lua     # 商店面板逻辑（商品加载、购买处理）
│   ├── ItemGrid.lua      # 道具格子组件（显示图标、数量、点击事件）
│   ├── ItemDes.lua       # 道具详情面板（展示道具完整信息）
│   ├── ItemManager.lua   # 道具管理单例（添加/删除/查询道具）
│   ├── PlayerData.lua    # 玩家数据管理（金币、背包数据存储）
│   └── ItemData.lua      # 道具配置解析（读取 JSON 配置）
├── ABResources/          # 资源文件目录（用于打包 AB 包）
│   ├── UI/               # UI 预制体（背包面板、商店面板、道具格子等）
│   ├── Json/             # 配置文件（ItemData.json 道具配置）
│   └── Sprites/          # 图片资源（道具图标、UI 背景等）
└── Scripts/              # C# 核心代码目录（与 Lua 交互、资源管理）
    └── ABManager.cs      # AB 包管理器（加载 AB 包、获取资源）
🚀 快速开始
环境要求
Unity 2022.3 或更高版本（需支持 UGUI、AB 包功能）
xLua 框架已导入项目（参考 xLua 官方文档 配置）
基础 C# 环境（支持与 Lua 交互的基础代码）
安装步骤
克隆项目：打开终端，执行以下命令克隆项目到本地
bash
git clone https://github.com/yourusername/unity-lua-inventory-system.git

打开项目：启动 Unity，选择「Open Project」，导入克隆的项目文件夹
配置 xLua：
确认 Assets/XLua 目录存在（若无，需手动导入 xLua 包）
点击菜单栏「XLua → Generate Code」生成 Lua 绑定代码
点击「XLua → Clear Generated Code」清除旧代码（若有报错冲突）
运行测试：
在 Unity Project 窗口中找到「Scenes」目录下的测试场景（如 MainScene.unity）
点击编辑器工具栏的「Play」按钮，体验背包与商店功能
🎮 使用说明
基础操作流程
操作目标	操作步骤
打开背包	在主界面点击「角色」图标，触发 BagPanel:Show() 方法显示背包面板
切换道具分类	点击背包顶部的「装备」「道具」「宝石」标签，触发分类筛选逻辑
查看道具详情	点击任意道具格子，调用 ItemDes:Show(itemData) 显示详情面板
购买道具	1. 打开商店面板（主界面「商店」图标）
2. 选择目标商品
3. 输入购买数量
4. 点击「购买」按钮（需确保金币充足）
道具数据配置
所有道具信息在 ABResources/Json/ItemData.json 中定义，格式如下（可直接新增 / 修改）：

json
{
  "id": 1,               // 道具唯一ID（不可重复）
  "name": "弓箭",         // 道具名称
  "icon": "Icon_2",       // 道具图标（对应 Sprites 目录下的图片名）
  "type": 1,             // 道具类型（1=装备，2=道具，3=宝石）
  "tips": "威力巨大的远程武器，适合后排角色使用",  // 道具描述
  "price": 100,          // 商店售价（单位：金币）
  "maxStack": 1          // 最大堆叠数量（装备类通常为1，消耗品类可设为99）
}
🔧 扩展开发
1. 添加新道具类型
以「消耗品」类型为例，步骤如下：

修改配置：在 ItemData.json 中新增道具，设置 type: 4（自定义类型值）
json
{
  "id": 10,
  "name": "体力药水",
  "icon": "Icon_Potion",
  "type": 4,          // 新增「消耗品」类型
  "tips": "使用后恢复50点体力",
  "price": 50,
  "maxStack": 99
}

扩展逻辑：在 ItemManager.lua 中添加类型判断与处理方法
lua
-- 新增消耗品使用逻辑
function ItemManager:UseConsumable(itemId)
    local item = self:GetItemById(itemId)
    if not item then return false end
    
    -- 调用玩家数据接口恢复体力
    PlayerData:AddStamina(50)
    -- 减少道具数量
    self:ReduceItem(itemId, 1)
    return true
end

UI 适配：在 BagPanel.lua 中添加「消耗品」分类标签，并绑定筛选逻辑
lua
-- 新增分类标签点击事件
self.consumableTab.onClick:AddListener(function()
    self:FilterItemsByType(4)  -- 筛选类型为4的道具
end)

2. 自定义 UI 样式
若需修改背包界面风格，步骤如下：

编辑预制体：在 Unity 中打开 ABResources/UI/BagPanel.prefab，修改背景、按钮、字体等样式
更新控件引用：若调整了 UI 控件名称，需在 BagPanel.lua 中同步修改引用
lua
-- 原引用（示例）
self.gridParent = self.transform:Find("Content/GridParent")
-- 若控件名称改为「ItemGridParent」，需同步修改
self.gridParent = self.transform:Find("Content/ItemGridParent")

调整布局：修改 ItemGrid.lua 中的格子大小、间距等参数，适配新 UI 样式
lua
-- 调整格子大小（原 80x80）
self.gridSize = Vector2(90, 90)
-- 调整格子间距（原 10）
self.gridSpacing = 15

📊 系统架构
text
Main.lua（入口）
├─ 初始化系统
│  ├─ 加载 AB 包资源 → ABManager.cs（C#）
│  └─ 解析道具配置 → ItemData.lua → 读取 ItemData.json
├─ 初始化管理器
│  ├─ 道具管理 → ItemManager.lua（单例）
│  │  └─ 依赖 PlayerData.lua（存储背包数据）
│  └─ UI 面板管理 → BasePanel.lua（基类）
│     ├─ 背包面板 → BagPanel.lua（继承 BasePanel）
│     ├─ 商店面板 → ShopPanel.lua（继承 BasePanel）
│     └─ 道具详情 → ItemDes.lua（继承 BasePanel）
└─ 绑定交互事件
   ├─ 背包打开/关闭 → BagPanel:Show()/Hide()
   ├─ 商店购买 → ShopPanel:OnBuyClick()
   └─ 道具使用 → ItemManager:UseItem()
🤝 贡献指南
欢迎开发者参与项目优化，贡献流程如下：

Fork 项目：点击 GitHub 仓库页面的「Fork」按钮，创建个人分支
创建特性分支：克隆个人仓库到本地，创建新分支开发功能
bash
git checkout -b feature/your-feature-name  # 示例：feature/add-skill-system

提交代码：完成开发后，提交代码并添加清晰的提交信息
bash
git add .
git commit -m "feat: 添加道具合成功能，支持3合1合成高级道具"

推送分支：将本地分支推送到 GitHub 个人仓库
bash
git push origin feature/your-feature-name

发起 Pull Request：在 GitHub 原仓库页面，点击「New Pull Request」，描述功能内容与修改点，等待审核
📝 更新日志
v1.0.0（2025-09-06）
初始版本发布，包含完整背包与商店核心功能
支持道具分类、详情预览、数量管理、商店购买
实现 xLua 热更新，核心逻辑（Lua 代码）支持运行时重载
完成基础资源配置（UI 预制体、道具图标、JSON 配置）
🙏 致谢
xLua 团队：提供 Unity 热更新解决方案，简化 Lua 与 C# 交互流程
Unity Technologies：提供强大的游戏引擎，支持 UI 搭建、资源管理等核心功能
Shields.io：提供免费徽章生成服务，便于展示项目状态与依赖信息
📄 许可证
本项目采用 MIT 许可证，允许个人或商业项目自由使用、修改、分发，无需支付授权费用。详情请查看项目根目录下的 LICENSE 文件。
📧 联系信息
作者：YourName
邮箱：your.email@example.com
GitHub：@yourusername（欢迎关注与交流）

如果这个项目对你的开发有帮助，欢迎点击 GitHub 仓库右上角的 ⭐ Star 支持！

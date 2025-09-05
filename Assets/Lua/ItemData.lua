--将Json数据读取到Lua中的表中进行存储

--首先应该先把json表从AB包中加载出来
--加载的Json文件 TextAsset对象
local txt = ABManager:LoadRes("json", "ShopItemData", typeof(TextAsset))
--获取它的文本信息 进行Json解析

--decode: 解析Json数据
local itemList = Json.decode(txt.text)
print(itemList)
--print(itemList[1].id .. itemList[1].name .. itemList[1].tips)

--加载出来是一个像数组结构的数据
--不方便通过id去获取里面的内容 所以用一张新表转存一次
--而且这张新的道具表 在任何地方都能够被使用
--一张用来存取道具信息的表 
--键值对形式 键是道具ID 值是道具表的一栏信息
ItemData = {}
for _, value in pairs(itemList) do
    ItemData[value.id] = value
end

--继承基类
BasePanel:subClass("ShopPanel")
--"成员变量"
ShopPanel.Content = nil
--用来存储当前显示的格子
ShopPanel.items = {}
--用来显示的页签类型 避免重复刷新
ShopPanel.nowType = -1
ShopPanel.itemDes = nil
ShopPanel.searchInput = nil

function ShopPanel:Init(name)
    self.base.Init(self, name)
    if self.isInitEvent == false then
        self.Content = self:GetControl("svBag","ScrollRect").transform:Find("Viewport"):Find("Content")
        self.searchInput = self.panelObj.transform:Find("shop"):Find("shop2"):Find("searchHolder"):GetComponent(typeof(InputField))
        self:GetControl("togAll","Toggle").onValueChanged:AddListener(function (value)
            if value == true then
                self:ChangeType(4)
            end
        end)
        self:GetControl("togEquip","Toggle").onValueChanged:AddListener(function (value)
            if value == true then
                self:ChangeType(1)
            end
        end)
        self:GetControl("togItem","Toggle").onValueChanged:AddListener(function (value)
            if value == true then
                self:ChangeType(2)
            end
        end)
        self:GetControl("togGam","Toggle").onValueChanged:AddListener(function (value)
            if value == true then
                self:ChangeType(3)
            end
        end)
        self:GetControl("btnClose","Button").onClick:AddListener(function ()
            self:HideMe()
        end)
         self:GetControl("btnSearch","Button").onClick:AddListener(function ()
            self:OnSearchClick()
        end)
        self.itemDes = ItemDes:new()
        self.itemDes:Init(self.panelObj.transform, GridType.shop)
        self.isInitEvent = true
    end
    
end

function ShopPanel:ChangeType(type)
    --如果要打开的是当前界面，就不重复执行了 --添加搜索功能后不执行会有问题
    --搜索过一次再搜索会导致无法显示所有道具，因为此时nowType == type，设置页面的代码会执行不到
    -- if self.nowType == type then
    --     return
    -- end
    --设置当前的界面为打开的界面
    self.nowType = type
    self.searchInput.text = ""
    self:ShowItems(type)
end

function ShopPanel:ShowItems(type,searchitems)
    if searchitems and #searchitems == 0 then
        TipsPanel:Show("未找到道具")
        self.searchInput.text = ""
        return
    end
    --删除所有格子
    for i = 1, #self.items do
        self.items[i]:Destroy()
    end
    self.items = {}
    --创建所有格子
    local nowItems = nil
    if type ~= nil and type then
        nowItems = ShopItemData.Instance():GetItemsByType(type)
    else
        nowItems = searchitems
    end
    --创建格子
    for i = 1, #nowItems do
        local grid = ItemGrid:new()
        grid:Init(self.Content,(i-1)%4 * 165,-math.floor((i-1)/4) * 165,GridType.shop)
        grid:InitData(nowItems[i])
        table.insert(self.items,grid)
        local ItemDesPanel = self.panelObj.transform:Find("ItemDesPanel")
        if ItemDesPanel then
            ItemDesPanel.gameObject:SetActive(false)
        end
    end
end

-- 点击搜索按钮
function ShopPanel:OnSearchClick()
    local searchText = ""
    if self.searchInput then
        searchText = self.searchInput.text
    end
    
    self:OnSearch(searchText)
end

-- 执行搜索
function ShopPanel:OnSearch(searchText)
    if not searchText or searchText == "" then
        -- 搜索框为空，显示当前类型的所有道具
        self:ChangeType(self.nowType)
    else
        -- 执行搜索
        self:ShowItemsByType(self.nowType, searchText)
    end
end

-- 根据类型显示道具
function ShopPanel:ShowItemsByType(itemType, searchText)
    local allItems = ShopItemData.Instance():GetItemsByType(itemType)
    --self.items = {}
    
    if searchText and searchText ~= "" then
        -- 执行搜索(道具类型'table'，搜索文本'string')
        --self.items = self:SearchItems(allItems, searchText)
        allItems = self:SearchItems(allItems, searchText)
    end
    
    -- 显示道具
    self:ShowItems(nil,allItems)
end

-- 搜索道具
function ShopPanel:SearchItems(items, searchText)
    local results = {}
    
    -- 清理搜索文本
    searchText = string.gsub(searchText, "^%s*(.-)%s*$", "%1")
    if searchText == "" then
        return items
    end
    
    for _, item in ipairs(items) do
        local itemConfig = ItemData[item.id]
        if itemConfig then
            -- 直接使用 string.find 的纯文本模式
            local nameMatch = string.find(itemConfig.name or "", searchText, 1, true)
            local descMatch = string.find(itemConfig.tips or "", searchText, 1, true)
            local idMatch = tostring(item.id) == searchText
            
            if nameMatch or descMatch or idMatch then
                table.insert(results, item)
            end
        end
    end
    
    print("搜索 '" .. searchText .. "' 找到 " .. #results .. " 个结果")
    self.searchInput.text = ""
    return results
end

function ShopPanel:ShowMe(name)
    self.base.ShowMe(self,name)
    if self.nowType == -1 then
        self:ChangeType(4)
        self:GetControl("togAll","Toggle").isOn = true
    end
end

function ShopPanel:HideMe()
    self.base.HideMe(self)
    self.nowType = -1
    local ItemDesPanel = self.panelObj.transform:Find("ItemDesPanel")
    if ItemDesPanel then
        ItemDesPanel.gameObject:SetActive(false)
    end
end
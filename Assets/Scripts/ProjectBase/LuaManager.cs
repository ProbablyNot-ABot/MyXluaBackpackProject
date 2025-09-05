using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using XLua;

/// <summary>
/// Lua管理器
/// 提供 lua解析器
/// 保证解析器的唯一性
/// </summary>
public class LuaManager : BaseManager<LuaManager>
{
    //执行Lua语言的函数
    //释放垃圾
    //销毁
    //重定向
    private LuaEnv luaEnv;

    /// <summary>
    /// 得到Lua中的_G
    /// </summary>
    public LuaTable Global
    {
        get
        {
            return luaEnv.Global;
        }
    }

    /// <summary>
    /// 初始化解析器
    /// </summary>
    public void Init()
    {
        if (luaEnv != null)
            return;
        //初始化解析器
        luaEnv = new LuaEnv();
        luaEnv.AddLoader(MyCustomLoader);
        //luaEnv.AddLoader(MyCustomABLoader);
    }

    private byte[] MyCustomLoader(ref string filepath)
    {
        //通过函数中的逻辑去加载Lua文件
        //传入的参数时require执行的lua脚本文件名
        //拼接一个Lua文件所在路径
        string path = Application.dataPath + "/Lua/" + filepath + ".lua";

        //有路径就去加载文件
        //File知识点 C#提供的文件读写的类
        //判断文件是否存在
        if (File.Exists(path))
        {
            return File.ReadAllBytes(path);
        }
        else
        {
            Debug.Log("MyCustomLoader重定向失败，文件名: " + path);
            return null;
        }

    }

    //Lua脚本会放在AB包
    //最终我们会通过加载AB包再加载其中的Lua脚本资源 来执行它
    //AB包中如果要加载文本 后缀还是有一定的限制 .lua不能被识别到
    //打包时要把lua文件后缀改为.txt
    //重定向加载AB包中的Lua脚本
    private byte[] MyCustomABLoader(ref string filepath)
    {
        //Debug.Log("进入AB包加载 重定向函数");
        ////从AB包中加载Lua文件
        ////加载AB包
        //string path = Application.streamingAssetsPath + "/lua";
        //AssetBundle ab = AssetBundle.LoadFromFile(path);

        ////加载Lua文件 返回
        //TextAsset tx = ab.LoadAsset<TextAsset>(filepath + ".lua");
        ////加载出了Lua文件 byte数组
        //return tx.bytes;

        //通过AB包管理器加载Lua文件
        TextAsset lua = ABManager.Instance().LoadRes<TextAsset>("lua", filepath + ".lua");
        if (lua != null)
            return lua.bytes;
        else
            Debug.Log("MyCustomABLoader重定向失败，文件名为: " + filepath);
        return null;
    }    

    /// <summary>
    /// 传入lua文件名执行lua脚本
    /// </summary>
    /// <param name="fileName"></param>
    public void DoLuaFile(string fileName)
    {
        string str = string.Format("require('{0}')", fileName);
        DoString(str);
    }

    /// <summary>
    /// 执行lua语言
    /// </summary>
    /// <param name="str"></param>
    public void DoString(string str)
    {
        if(luaEnv == null)
        {
            Debug.LogError("解析器未初始化");
            return;
        }
        luaEnv.DoString(str);    
    }

    /// <summary>
    /// 释放lua垃圾
    /// </summary>
    public void Tick()
    {
        if (luaEnv == null)
        {
            Debug.LogError("解析器未初始化");
            return;
        }
        luaEnv.Tick();
    }

    /// <summary>
    /// 销毁解析器
    /// </summary>
    public void Dispose()
    {
        if (luaEnv == null)
        {
            Debug.LogError("解析器未初始化");
            return;
        }
        luaEnv.Dispose();
        luaEnv = null;
    }

}

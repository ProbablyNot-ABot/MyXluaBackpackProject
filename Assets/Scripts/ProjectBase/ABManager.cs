using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
using UnityEngine;
using UnityEngine.Events;

public class ABManager : SingletonAutoMono<ABManager>
{
    //AB包管理器 目的是
    //让外部更方便进行资源加载

    //主AB包
    private AssetBundle mainAB = null; 

    //依赖包获取用的配置文件
    private AssetBundleManifest manifest = null;

    //AB包不能重复加载,否则报错
    //用字典存储加载过的AB包
    //key: AB包名, value: AB包对象
    private Dictionary<string,AssetBundle> abDic = new Dictionary<string, AssetBundle>();

    /// <summary>
    /// AB包存放路径 方便修改
    /// </summary>
    private string PathUrl
    {
        get
        {
            return Application.streamingAssetsPath + "/";
        }
    }

    /// <summary>
    /// 主包名 方便修改
    /// </summary>
    private string MainABName
    {
        get
        {
#if UNITY_IOS
            return "PC";
#elif UNITY_ANDROID
            return "Android";
#else
            return "PC";
#endif
        }
    }

    /// <summary>
    /// 加载AB包
    /// </summary>
    /// <param name="abName">AB包名</param>
    private void LoadAB(string abName)
    {
        //加载AB包
        if (mainAB == null)
        {
            mainAB = AssetBundle.LoadFromFile(PathUrl + MainABName);
            manifest = mainAB.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
        }

        //获取依赖包相关信息
        AssetBundle ab = null;
        string[] strs = manifest.GetAllDependencies(abName);
        for (int i = 0; i < strs.Length; i++)
        {
            //判断包是否已经加载过
            if (!abDic.ContainsKey(strs[i]))
            {
                ab = AssetBundle.LoadFromFile(PathUrl + strs[i]);
                Debug.Log("加载依赖包: " + strs[i]);
                abDic.Add(strs[i], ab);
            }
        }

        //加载资源来源包
        //如果没有加载过 再加载
        if (!abDic.ContainsKey(abName))
        {
            ab = AssetBundle.LoadFromFile(PathUrl + abName);
            abDic.Add(abName, ab);
        }
        //else
            //Debug.Log("AB包: " + abName + " 已经加载过了，" + "不会重复加载");
    }

    //同步加载 不指定类型
    public Object LoadRes(string abName,string resName)
    {    
        //加载AB包
        LoadAB(abName);
        //为了外面方便 在加载资源时 判断一下 资源是不是GameObject
        //如果是 直接实例化了 再返回给外部
        Object obj = abDic[abName].LoadAsset(resName);
        if(obj is GameObject)
            return Instantiate(obj);
        else
            return obj;
    }

    //同步加载 根据type指定类型
    public Object LoadRes(string abName, string resName, System.Type type)
    {
        LoadAB(abName);
        //为了外面方便 在加载资源时 判断一下 资源是不是GameObject
        //如果是 直接实例化了 再返回给外部
        Object obj = abDic[abName].LoadAsset(resName,type);
        if (obj is GameObject)
            return Instantiate(obj);
        else
            return obj;
    }

    //同步加载 根据泛型指定类型
    public T LoadRes<T>(string abName, string resName) where T : Object
    {
        LoadAB(abName);
        //为了外面方便 在加载资源时 判断一下 资源是不是GameObject
        //如果是 直接实例化了 再返回给外部
        T obj = abDic[abName].LoadAsset<T>(resName);
        if (obj is GameObject)
            return Instantiate(obj);
        else
            return obj;
    }

    //异步加载
    //这里的异步加载 AB包并没有使用异步加载
    //只是从AB包中 加载资源时 使用了异步加载
    //根据名字异步加载资源
    public void LoadResAsync(string abName, string resName, UnityAction<Object> callBack)
    {
        StartCoroutine(ReallyLoadRes(abName, resName, callBack));
    }
    private IEnumerator ReallyLoadRes(string abName, string resName, UnityAction<Object> callBack)
    {
        //加载AB包
        LoadAB(abName);
        //为了外面方便 在加载资源时 判断一下 资源是不是GameObject
        //如果是 直接实例化了 再返回给外部
        AssetBundleRequest abr = abDic[abName].LoadAssetAsync(resName);
        yield return abr;
        
        //异步加载结束后通过委托传递给外部使用
        if (abr.asset is GameObject)
            callBack(Instantiate(abr.asset));
        else
            callBack(abr.asset);
    }

    //根据type异步加载资源
    public void LoadResAsync(string abName, string resName, System.Type type, UnityAction<Object> callBack)
    {
        StartCoroutine(ReallyLoadRes(abName, resName, type, callBack));
    }
    private IEnumerator ReallyLoadRes(string abName, string resName, System.Type type, UnityAction<Object> callBack)
    {
        //加载AB包
        LoadAB(abName);
        //为了外面方便 在加载资源时 判断一下 资源是不是GameObject
        //如果是 直接实例化了 再返回给外部
        AssetBundleRequest abr = abDic[abName].LoadAssetAsync(resName,type);
        yield return abr;

        //异步加载结束后通过委托传递给外部使用
        if (abr.asset is GameObject)
            callBack(Instantiate(abr.asset));
        else
            callBack(abr.asset);
    }

    //根据泛型异步加载资源
    public void LoadResAsync<T>(string abName, string resName, UnityAction<T> callBack) where T : Object
    {
        StartCoroutine(ReallyLoadRes<T>(abName, resName, callBack));
    }
    private IEnumerator ReallyLoadRes<T>(string abName, string resName, UnityAction<T> callBack) where T : Object
    {
        //加载AB包
        LoadAB(abName);
        //为了外面方便 在加载资源时 判断一下 资源是不是GameObject
        //如果是 直接实例化了 再返回给外部
        AssetBundleRequest abr = abDic[abName].LoadAssetAsync<T>(resName);
        yield return abr;

        //异步加载结束后通过委托传递给外部使用
        if (abr.asset is GameObject)
            callBack(Instantiate(abr.asset) as T);
        else
            callBack(abr.asset as T);
    }

    //单个包卸载
    public void UnLoad(string abName)
    {
        if (abDic.ContainsKey(abName))
        {
            abDic[abName].Unload(false);
            abDic.Remove(abName);
            Debug.Log("AB包 " + abName + " 已卸载");
        }
        else
            Debug.LogError("AB包不存在: " + abName);
    }

    //所有包卸载
    public void ClearAB()
    {
        AssetBundle.UnloadAllAssetBundles(false);
        abDic.Clear();
        mainAB = null;
        manifest = null;
        Debug.Log("已卸载所有AB包");
    }
}

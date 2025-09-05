using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SingletonAutoMono<T> : MonoBehaviour where T : MonoBehaviour
{
    private static T instance;
    public static T Instance()
    {
        if (instance == null)
        {
            GameObject obj = new GameObject();
            //设置对象的名字为脚本名
            obj.name = typeof(T).ToString();
            //让这个单例模式对象过场景时不被移除
            //因为单例模式对象往往时存在整个程序生命周期中的
            DontDestroyOnLoad(obj);
            instance = obj.AddComponent<T>();
        }
        return instance;
    }
}

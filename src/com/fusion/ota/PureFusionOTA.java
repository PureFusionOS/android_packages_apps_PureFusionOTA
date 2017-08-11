package com.fusion.ota;

import android.app.Application;
import android.support.v4.util.ArrayMap;
import android.util.Log;

import java.util.Set;

public class PureFusionOTA extends Application {
    private static ArrayMap<Integer, Long> mAddonsDownloads = new ArrayMap<>();

    public static void putAddonDownload(int key, long value) {
        Log.d("PureFusionOTA", "Putting Addon with Key: " + key + " and Value: " + value);
        mAddonsDownloads.put(key, value);
    }

    public static long getAddonDownload(int key) {
        Log.d("PureFusionOTA", "Getting Addon with Key: " + key);
        return mAddonsDownloads.get(key);
    }

    public static long getAddonDownloadValueAtIndex(int index) {
        return mAddonsDownloads.get(mAddonsDownloads.valueAt(index));
    }

    public static void removeAddonDownload(int key) {
        mAddonsDownloads.remove(key);
    }

    public static Set<Integer> getAddonDownloadKeySet() {
        return mAddonsDownloads.keySet();
    }
}

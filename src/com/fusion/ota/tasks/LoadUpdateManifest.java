/*
 * Copyright (C) 2015 Matt Booth (Kryten2k35).
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); 
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.fusion.ota.tasks;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.preference.SwitchPreference;
import android.util.Log;

import com.fusion.ota.R;
import com.fusion.ota.utils.Constants;
import com.fusion.ota.utils.Preferences;
import com.fusion.ota.activities.SettingsActivity;
import com.fusion.ota.utils.Utils;

import android.preference.Preference;
import android.preference.Preference.OnPreferenceChangeListener;
import android.preference.Preference.OnPreferenceClickListener;
import android.preference.PreferenceActivity;
import android.preference.PreferenceManager;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.Set;

public class LoadUpdateManifest extends AsyncTask<Void, Void, Void> implements Constants {

    private static final String MANIFEST = "update_manifest.xml";
    private Boolean BETA/* = SettingsActivity.mBeta.getBoolean("beta_opt_in", true)*/; // Whether to load the BETA manifest or not
    public final String TAG = this.getClass().getSimpleName();
    // Did this come from the BackgroundReceiver class?
    boolean shouldUpdateForegroundApp;
    private Context mContext;
    private ProgressDialog mLoadingDialog;

    public LoadUpdateManifest(Context context, boolean input) {
        mContext = context;
        shouldUpdateForegroundApp = input;
        SwitchPreference Beta;
        /*if (PreferenceManager.getDefaultSharedPreferences(mContext).getBoolean("beta_opt_in", true));*/
    }

    @Override
    protected void onPreExecute() {
        if (shouldUpdateForegroundApp) {
            mLoadingDialog = new ProgressDialog(mContext);
            mLoadingDialog.setIndeterminate(true);
            mLoadingDialog.setCancelable(false);
            mLoadingDialog.setMessage(mContext.getResources().getString(R.string.loading));
            mLoadingDialog.show();
        }

        File manifest = new File(mContext.getFilesDir().getPath(), MANIFEST);
        if (manifest.exists()) {
            manifest.delete();
        }
    }

    @Override
    protected Void doInBackground(Void... v) {

        BETA = Preferences.getBeta(mContext);

        try {
            InputStream input = null;

            URL url;
            if (DEBUGGING) {
                url = new URL("https://romhut.com/roms/aosp-jf/ota.xml");
            } else if (BETA) {
                url = new URL(Utils.getProp("ro.ota.BETAmanifest").trim());
            } else {
                url = new URL(Utils.getProp("ro.ota.manifest").trim());
            }
            URLConnection connection = url.openConnection();
            connection.connect();
            // download the file
            input = new BufferedInputStream(url.openStream());

            OutputStream output = mContext.openFileOutput(
                    MANIFEST, Context.MODE_PRIVATE);

            byte data[] = new byte[1024];
            int count;
            while ((count = input.read(data)) != -1) {
                output.write(data, 0, count);
            }

            output.flush();
            output.close();
            input.close();

            // file finished downloading, parse it!
            RomXmlParser parser = new RomXmlParser();
            parser.parse(new File(mContext.getFilesDir(), MANIFEST),
                    mContext);
        } catch (Exception e) {
            Log.d(TAG, "Exception: " + e.getMessage());
        }
        return null;
    }

    @Override
    protected void onPostExecute(Void result) {
        Intent intent;
        if (shouldUpdateForegroundApp) {
            mLoadingDialog.cancel();
            intent = new Intent(MANIFEST_LOADED);
        } else {
            intent = new Intent(MANIFEST_CHECK_BACKGROUND);
        }

        mContext.sendBroadcast(intent);
        super.onPostExecute(result);
    }
}
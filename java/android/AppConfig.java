package de.nerdno.rtfm.util;

import android.content.Context;
import android.content.SharedPreferences;

/**
 * Used as a central place to store/retrieve application preferences.
 */
public final class AppConfig {

    /** Shared application preferences. */
    public static final class PREFS {
        private static final String NAME = "RTFM";

        private static final String API_KEY = "API_KEY";

        /** Return the {@link SharedPreferences} instance. */
        private static SharedPreferences getPrefs(final Context context) {
            return context.getSharedPreferences(NAME, Context.MODE_PRIVATE);
        }

        public static String getApiKey(final Context context) {
            return getPrefs(context).getString(API_KEY, null);
        }

        public static boolean setApiKey(final Context context, final String apiKey) {
            return getPrefs(context)
                  .edit()
                  .putString(API_KEY, apiKey)
                  .commit();
        }
    }

}

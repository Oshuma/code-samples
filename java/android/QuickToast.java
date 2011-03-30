package de.nerdno.android.util;

import android.content.Context;
import android.widget.Toast;

/**
 * Wrapper for {@link android.widget.Toast} to easily show a {@link #showShort(Context, int) short} or {@link #showLong(Context, int) long} toast.
 */
public abstract class QuickToast extends Toast {

    public QuickToast(final Context context) {
        super(context);
    }

    /** Show a {@link android.widget.Toast} with a long duration. */
    public static void showLong(final Context context, final CharSequence text) {
        Toast.makeText(context, text, Toast.LENGTH_LONG).show();
    }

    /**
     * Converts resourceId to a String before passing it to {@link #showLong(Context, CharSequence)}.
     * @see #showLong(Context, CharSequence)
     */
    public static void showLong(final Context context, final int resourceId) {
        showLong(context, context.getResources().getString(resourceId));
    }

    /** Show a {@link android.widget.Toast} with a short duration. */
    public static void showShort(final Context context, final CharSequence text) {
        Toast.makeText(context, text, Toast.LENGTH_SHORT).show();
    }

    /**
     * Converts resourceId to a String before passing it to {@link #showShort(Context, CharSequence)}.
     * @see #showShort(Context, CharSequence)
     */
    public static void showShort(final Context context, final int resourceId) {
        showShort(context, context.getResources().getString(resourceId));
    }

}

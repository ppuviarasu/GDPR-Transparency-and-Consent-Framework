package com.appnexus.inappcmpreference;


import android.content.Context;
import android.preference.PreferenceManager;

/**
 * Used to retrieve and store the consentData, subjectToGdpr, vendors and purposes in the SharedPreferences
 */
public class CMPStorage {

    private static final String CONSENT_STRING = "IABConsent_ConsentString";
    private static final String SUBJECT_TO_GDPR = "IABConsent_SubjectToGDPR";
    private static final String CMP_PRESENT = "IABConsent_CMPPresent";
    private static final String EMPTY_DEFAULT_STRING = "";

    /**
     * Returns the websafe base64-encoded consent String stored in the SharedPreferences
     *
     * @param context Context used to access the SharedPreferences
     * @return the stored websafe base64-encoded consent String
     */
    public static String getConsentString(Context context) {
        return PreferenceManager.getDefaultSharedPreferences(context).getString(CONSENT_STRING, EMPTY_DEFAULT_STRING);
    }

    /**
     * Stores the passed websafe base64-encoded consent String in the SharedPreferences
     *
     * @param context       Context used to access the SharedPreferences
     * @param consentString the websafe base64-encoded consent String to be stored
     */
    public static void setConsentString(Context context, String consentString) {
        PreferenceManager.getDefaultSharedPreferences(context).edit().putString(CONSENT_STRING, consentString).apply();
    }

    /**
     * Returns the {@link SubjectToGdpr} stored in the SharedPreferences
     *
     * @param context Context used to access the SharedPreferences
     * @return the stored {@link SubjectToGdpr}
     */
    public static SubjectToGdpr getSubjectToGdpr(Context context) {
        String subjectToGdpr = PreferenceManager.getDefaultSharedPreferences(context)
                .getString(SUBJECT_TO_GDPR, SubjectToGdpr.CMPGDPRUnknown.getValue());
        return SubjectToGdpr.getValueForString(subjectToGdpr);
    }

    /**
     * Stores the passed {@link SubjectToGdpr} in the SharedPreferences
     *
     * @param context       Context used to access the SharedPreferences
     * @param subjectToGdpr the {@link SubjectToGdpr} to be stored
     */
    public static void setSubjectToGdpr(Context context, SubjectToGdpr subjectToGdpr) {
        PreferenceManager.getDefaultSharedPreferences(context).edit().putString(SUBJECT_TO_GDPR, subjectToGdpr.getValue()).apply();
    }

    /**
     * Returns the CMP present boolean stored in the SharedPreferences
     *
     * @return {@code true} if a CMP implementing the iAB specification is present in the application, otherwise {@code false};
     */
    public static boolean getCmpPresentValue(Context context) {
        return PreferenceManager.getDefaultSharedPreferences(context).getBoolean(CMP_PRESENT, false);
    }

    /**
     * Stores the CMP present boolean in SharedPreferences
     *
     * @param cmpPresent indicates whether a CMP implementing the iAB specification is present in the application
     */
    public static void setCmpPresentValue(Context context, boolean cmpPresent) {
        PreferenceManager.getDefaultSharedPreferences(context).edit().putBoolean(CMP_PRESENT, cmpPresent).apply();
    }

}
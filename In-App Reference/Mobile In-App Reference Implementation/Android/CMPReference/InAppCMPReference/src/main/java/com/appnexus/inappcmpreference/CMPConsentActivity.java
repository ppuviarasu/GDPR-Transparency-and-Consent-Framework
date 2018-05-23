package com.appnexus.inappcmpreference;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.annotation.RequiresApi;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.LinearLayout;


public class CMPConsentActivity extends Activity {
    private static final String CMP_SETTINGS_EXTRA = "cmp_settings";

    private WebView webView;
    private static OnCloseCallback onCloseCallback;

    private CMPSettings cmpSettings;

    /**
     * Used to start the Activity where the consentToolUrl is loaded into WebView
     *
     * @param cmpSettings setup the needed data to initialize consent tool api.
     *                    In case no prior consent can be found, it executes the
     *                    procedure of getting consent from the user, which means
     *                    loading the consentToolUrl provided by this object.
     * @param context     context
     * @param closeCallback listener called when CMPConsentActivity is closed after interacting with WebView
     */
    public static void showCMPConsentActivity(CMPSettings cmpSettings, Context context, OnCloseCallback closeCallback) {
        Intent cmpConsentToolIntent = new Intent(context, CMPConsentActivity.class);
        cmpConsentToolIntent.putExtra(CMP_SETTINGS_EXTRA, cmpSettings);
        CMPConsentActivity.onCloseCallback = closeCallback;
        context.startActivity(cmpConsentToolIntent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        cmpSettings = getCMPSettingsExtra();

        if (cmpSettings == null) {
            CMPStorage.setSubjectToGdpr(this, SubjectToGdpr.CMPGDPRUnknown);
            clearConsentStringPurposesAndVendors();
            finish();
            return;
        }

        CMPStorage.setSubjectToGdpr(this, cmpSettings.getSubjectToGdpr());

        if (TextUtils.isEmpty(cmpSettings.getConsentToolUrl())) {
            clearConsentStringPurposesAndVendors();
            finish();
            return;
        }

        createLayout();

        webView.getSettings().setJavaScriptEnabled(true);
        webView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
        webView.getSettings().setAppCacheEnabled(false);
        handleConsentSettings();
        webView.loadUrl(cmpSettings.getConsentToolUrl());

        setupWebViewClient();
    }

    private void createLayout() {
        LinearLayout linearLayout = new LinearLayout(this);
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT);

        webView = new WebView(this);

        webView.setLayoutParams(layoutParams);

        linearLayout.addView(webView);

        setContentView(linearLayout, layoutParams);
    }

    private void handleConsentSettings() {
        Uri uri;

        if (!TextUtils.isEmpty(cmpSettings.getConsentString())) {
            uri = Uri.parse(cmpSettings.getConsentToolUrl()).buildUpon().appendQueryParameter("code64", cmpSettings.getConsentString()).build();
            cmpSettings.setConsentToolUrl(uri.toString());
        } else {
            String consentString = CMPStorage.getConsentString(this);

            if (!TextUtils.isEmpty(consentString)) {
                uri = Uri.parse(cmpSettings.getConsentToolUrl()).buildUpon().appendQueryParameter("code64", consentString).build();
                cmpSettings.setConsentToolUrl(uri.toString());
                cmpSettings.setConsentString(consentString);
            }
        }
    }

    private CMPSettings getCMPSettingsExtra() {
        return (CMPSettings) getIntent().getSerializableExtra(CMP_SETTINGS_EXTRA);
    }

    private void setupWebViewClient() {
        GDPRWebViewClient gdprWebViewClient = new GDPRWebViewClient();
        webView.setWebViewClient(gdprWebViewClient);
    }

    private void clearConsentStringPurposesAndVendors() {
        CMPStorage.setConsentString(this, null);
    }

    private class GDPRWebViewClient extends WebViewClient {
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            handleWebViewInteraction(url);
            return true;
        }

        @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
            handleWebViewInteraction(String.valueOf(request.getUrl()));
            return true;
        }

        private void handleWebViewInteraction(String url) {

            if(url.contains("consent://")) {

                handleReceivedConsentString(url);

                if (onCloseCallback != null) {
                    onCloseCallback.onCMPConsentActivityFinish();
                    onCloseCallback = null;
                }

                finish();

            }
            else{
                Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
                startActivity(browserIntent);
            }
        }

        private void handleReceivedConsentString(String url) {
            String[] values = new String[0];

            if (url != null) {
                values = url.split("consent://");
            }

            if (values.length > 1) {
                CMPStorage.setConsentString(CMPConsentActivity.this, values[1]);
            } else {
                clearConsentStringPurposesAndVendors();
            }
        }
    }
}
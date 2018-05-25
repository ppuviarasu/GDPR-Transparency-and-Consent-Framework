package com.appnexus.opensdk.samplecmpintegration;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.text.method.ScrollingMovementMethod;
import android.widget.TextView;

import com.appnexus.opensdk.utils.Clog;
import com.appnexus.opensdk.utils.StringUtil;

import org.json.JSONException;
import org.json.JSONObject;

public class DebugActivity extends AppCompatActivity {

    private TextView txtRequest,txtResponse ;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_debug);
        txtRequest = findViewById(R.id.txtRequest);
        txtResponse = findViewById(R.id.txtResponse);
        txtResponse.setMovementMethod(new ScrollingMovementMethod());
        txtRequest.setMovementMethod(new ScrollingMovementMethod());
        refresh();
    }
    protected void refresh() {

        if (txtResponse != null) {
            if (!StringUtil.isEmpty(Clog.getLastResponse())) {
                String jsonString = null;
                try {
                    JSONObject responseObject = new JSONObject(Clog.getLastResponse());
                    jsonString = responseObject.toString(4);
                } catch (JSONException e) {
                    Clog.e("AppNexus Request", "JSONException in response", e);
                }
                txtResponse.setText(jsonString != null ? jsonString : Clog.getLastResponse());
            } else{
                txtResponse.setText("Last response was empty");
            }
        }

        if (txtRequest != null) {
            if (!StringUtil.isEmpty(Clog.getLastRequest())) {
                String jsonString = null;
                try {
                    JSONObject responseObject = new JSONObject(Clog.getLastRequest());
                    jsonString = responseObject.toString(4);
                } catch (JSONException e) {
                    Clog.e("AppNexus Response", "JSONException in response", e);
                }
                txtRequest.setText(jsonString != null ? jsonString : Clog.getLastRequest());
            } else{
                txtRequest.setText("Last Request was empty");
            }
        }
    }


}

package com.safesplayce.livestream

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.webkit.WebResourceRequest
import android.webkit.WebSettings
import android.webkit.WebStorage
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.Button
import android.widget.ProgressBar

class MainActivity : Activity() {

    private lateinit var webView: WebView
    private lateinit var progress: ProgressBar
    private lateinit var btnGame: Button
    private lateinit var btnToolbox: Button

    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        webView = findViewById(R.id.webView)
        progress = findViewById(R.id.progress)
        btnGame = findViewById(R.id.btnGameConsole)
        btnToolbox = findViewById(R.id.btnToolboxConsole)

        // Wipe any leftovers from a previous build so stale/deleted files never leak in.
        WebStorage.getInstance().deleteAllData()

        webView.apply {
            settings.javaScriptEnabled = true
            settings.domStorageEnabled = true
            settings.cacheMode = WebSettings.LOAD_NO_CACHE
            settings.allowFileAccess = true
            settings.allowContentAccess = true
            settings.setSupportZoom(false)
            settings.builtInZoomControls = false
            settings.displayZoomControls = false
            settings.loadWithOverviewMode = true
            settings.useWideViewPort = true
            webViewClient = object : WebViewClient() {
                override fun onPageStarted(view: WebView?, url: String?, favicon: android.graphics.Bitmap?) {
                    progress.visibility = android.view.View.VISIBLE
                }

                override fun onPageFinished(view: WebView?, url: String?) {
                    progress.visibility = android.view.View.GONE
                }

                override fun shouldOverrideUrlLoading(view: WebView?, request: WebResourceRequest?): Boolean {
                    val url = request?.url?.toString() ?: return false

                    // Let the app switch between the two bundled consoles.
                    if (url == GAME_CONSOLE_URL || url == TOOLBOX_CONSOLE_URL) {
                        return false
                    }

                    // Everything else (helpline links, etc.) goes to the browser so the
                    // consoles stay a safe, offline container.
                    runCatching {
                        startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))
                    }
                    return true
                }
            }
        }

        btnGame.setOnClickListener { webView.loadUrl(GAME_CONSOLE_URL) }
        btnToolbox.setOnClickListener { webView.loadUrl(TOOLBOX_CONSOLE_URL) }

        // Load the Game Console first; it is the primary deck dealer.
        webView.loadUrl(GAME_CONSOLE_URL)
    }

    override fun onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack()
        } else {
            super.onBackPressed()
        }
    }

    companion object {
        private const val GAME_CONSOLE_URL = "file:///android_asset/game-console.html"
        private const val TOOLBOX_CONSOLE_URL = "file:///android_asset/toolbox-console.html"
    }
}

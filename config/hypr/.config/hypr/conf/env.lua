-----------------------------
--- ENVIRONMENT VARIABLES ---
-----------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- GCR
hl.env("SSH_AUTH_SOCK", os.getenv("XDG_RUNTIME_DIR") .. "/gcr/ssh")

-- Qt apps (Quickshell included) follow GTK settings, so they share its icon theme.
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")

-- GTK 4 broke blur in some update
hl.env("GDK_WAYLAND_DISABLE", "ext_background_effect_manager_v1")

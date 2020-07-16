-- Client-side CFG

LIS = LIS or {}
LIS.CONFIG = {}

-- Controls (client-side)
LIS.CONFIG.MouseToggle = true -- Allow closing the window by clicking anywhere outside it
LIS.CONFIG.ShowCloseButton = true -- Allow closing the window by clicking the close button located at the top right corner of it
LIS.CONFIG.EnableSwitchButton = true -- Allow switching between "compact" and "regular" modes by using the minimize/restore button

-- Appearance
LIS.CONFIG.PrimaryAccentColor = {66, 66, 72, 255} -- Primary Accent Colour
LIS.CONFIG.SecondaryAccentColor = {174, 174, 191, 255} -- Secondary Accent Colour

-- Appearance (Overwritable variables in case if you need more customization)
--LIS.CONFIG.BaseWindowBarColor = {66, 66, 72, 255} -- Base Window Bar Colour
--LIS.CONFIG.BaseWindowBackgroundColor = {66, 66, 72, 217} -- Base Window Background Colour
--LIS.CONFIG.BaseWindowCloseButtonColor = {174, 174, 191, 170}

-- Animation
LIS.CONFIG.OpeningAnimationTime = 0.25 -- Open/Close Animation (0 to disable)
LIS.CONFIG.ScrollAnimationTime = 0.25 -- Page scroll Animation (0 to disable)
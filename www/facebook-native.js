var exec = require('cordova/exec')

exports.logEvent = function (name, params, valueToSum, s, f) {
  // Prevent NSNulls getting into iOS, messes up our [command.argument count]
  if (!params && !valueToSum) {
    exec(s, f, 'FacebookConnectPlugin', 'logEvent', [name])
  } else if (params && !valueToSum) {
    exec(s, f, 'FacebookConnectPlugin', 'logEvent', [name, params])
  } else if (params && valueToSum) {
    exec(s, f, 'FacebookConnectPlugin', 'logEvent', [name, params, valueToSum])
  } else {
    f('Invalid arguments')
  }
}

exports.setAdvertiserTrackingEnabled = function (enabled, s, f) {
  exec(s, f, 'FacebookConnectPlugin', 'setAdvertiserTrackingEnabled', [enabled]);
}


/** @deprecated not used by Clarity */
exports.getApplicationId = function (s, f) {
  return f('getApplicationId is deprecated');

  exec(s, f, 'FacebookConnectPlugin', 'getApplicationId', [])
}

/** @deprecated not used by Clarity */
exports.setApplicationId = function (appId, s, f) {
  return f('setApplicationId is deprecated');

  exec(s, f, 'FacebookConnectPlugin', 'setApplicationId', [appId])
}

/** @deprecated not used by Clarity */
exports.getClientToken = function (s, f) {
  return f('getClientToken is deprecated');

  exec(s, f, 'FacebookConnectPlugin', 'getClientToken', [])
}

/** @deprecated not used by Clarity */
exports.setClientToken = function (clientToken, s, f) {
  return f('setClientToken is deprecated');

  exec(s, f, 'FacebookConnectPlugin', 'setClientToken', [clientToken])
}

/** @deprecated not used by Clarity */
exports.getApplicationName = function (s, f) {
  return f('getApplicationName is deprecated');

  exec(s, f, 'FacebookConnectPlugin', 'getApplicationName', [])
}

/** @deprecated not used by Clarity */
exports.setApplicationName = function (appName, s, f) {
  return f('setApplicationName is deprecated');

  exec(s, f, 'FacebookConnectPlugin', 'setApplicationName', [appName])
}

/** @deprecated not used by Clarity */
exports.getLoginStatus = function (force, s, f) {
  return f('getLoginStatus is deprecated');

  if (typeof force === 'function') {
    s = force;
    f = s;
    force = false;
  }
  exec(s, f, 'FacebookConnectPlugin', 'getLoginStatus', [force])
}

/** @deprecated not used by Clarity */
exports.showDialog = function (options, s, f) {
  return f('showDialog is deprecated');

  exec(s, f, 'FacebookConnectPlugin', 'showDialog', [options])
}

/** @deprecated not used by Clarity */
exports.login = function (permissions, s, f) {
  return f('login is deprecated');

  exec(s, f, 'FacebookConnectPlugin', 'login', permissions)
}

/** @deprecated not used by Clarity */
exports.loginWithLimitedTracking = function (permissions, nonce, s, f) {
  return f('loginWithLimitedTracking is deprecated');

  if (!nonce) {
    exec(s, f, 'FacebookConnectPlugin', 'loginWithLimitedTracking', [permissions])
  } else {
    exec(s, f, 'FacebookConnectPlugin', 'loginWithLimitedTracking', [permissions, nonce])
  }
}

/** @deprecated not used by Clarity */
exports.checkHasCorrectPermissions = function (permissions, s, f) {
  return f('checkHasCorrectPermissions is deprecated');

  exec(s, f, 'FacebookConnectPlugin', 'checkHasCorrectPermissions', permissions)
}

/** @deprecated not used by Clarity */
exports.isDataAccessExpired = function (s, f) {
  return f('isDataAccessExpired is deprecated');

  exec(s, f, 'FacebookConnectPlugin', 'isDataAccessExpired', [])
}

/** @deprecated not used by Clarity */
exports.reauthorizeDataAccess = function (s, f) {
  return f('reauthorizeDataAccess is deprecated');

  exec(s, f, 'FacebookConnectPlugin', 'reauthorizeDataAccess', [])
}

/** @deprecated not used by Clarity */
exports.setAutoLogAppEventsEnabled = function (enabled, s, f) {
  return f('setAutoLogAppEventsEnabled is deprecated');

  exec(s, f, 'FacebookConnectPlugin', 'setAutoLogAppEventsEnabled', [enabled]);
}

/** @deprecated not used by Clarity */
exports.setAdvertiserIDCollectionEnabled = function (enabled, s, f) {
  return f('setAdvertiserIDCollectionEnabled is deprecated');

  exec(s, f, 'FacebookConnectPlugin', 'setAdvertiserIDCollectionEnabled', [enabled]);
}

/** @deprecated not used by Clarity */
exports.setDataProcessingOptions = function (options, country, state, s, f) {
  return f('setDataProcessingOptions is deprecated');

  if (!(country >= 0 && state >= 0)) {
    exec(s, f, 'FacebookConnectPlugin', 'setDataProcessingOptions', [options]);
  } else {
    exec(s, f, 'FacebookConnectPlugin', 'setDataProcessingOptions', [options, country, state]);
  }
}

/** @deprecated not used by Clarity */
exports.setUserData = function (userData, s, f) {
  return f('setUserData is deprecated');

  exec(s, f, 'FacebookConnectPlugin', 'setUserData', [userData])
}

/** @deprecated not used by Clarity */
exports.clearUserData = function (s, f) {
  return f('clearUserData is deprecated');

  exec(s, f, 'FacebookConnectPlugin', 'clearUserData', [])
}

/** @deprecated not used by Clarity */
exports.logPurchase = function (value, currency, params, s, f) {
  return f('logPurchase is deprecated');

  if (typeof params === 'function') {
    s = params;
    f = s;
    params = undefined;
  }
  if (!params) {
    exec(s, f, 'FacebookConnectPlugin', 'logPurchase', [value, currency])
  } else {
    exec(s, f, 'FacebookConnectPlugin', 'logPurchase', [value, currency, params])
  }
}

/** @deprecated not used by Clarity */
exports.getAccessToken = function (s, f) {
  return f('getAccessToken is deprecated');

  exec(s, f, 'FacebookConnectPlugin', 'getAccessToken', [])
}

/** @deprecated not used by Clarity */
exports.logout = function (s, f) {
  return f('logout is deprecated');

  exec(s, f, 'FacebookConnectPlugin', 'logout', [])
}

/** @deprecated not used by Clarity */
exports.getCurrentProfile = function (s, f) {
  return f('getCurrentProfile is deprecated');

  exec(s, f, 'FacebookConnectPlugin', 'getCurrentProfile', [])
}

/** @deprecated not used by Clarity */
exports.api = function (graphPath, permissions, httpMethod, s, f) {
  return f('api is deprecated');

  permissions = permissions || []
  if (typeof httpMethod === 'function') {
    s = httpMethod;
    f = s;
    httpMethod = undefined;
  }
  if (httpMethod) {
    httpMethod = httpMethod.toUpperCase();
    if (httpMethod != 'POST' && httpMethod != 'DELETE') {
      httpMethod = undefined;
    }
  }
  if (!httpMethod) {
    exec(s, f, 'FacebookConnectPlugin', 'graphApi', [graphPath, permissions])
  } else {
    exec(s, f, 'FacebookConnectPlugin', 'graphApi', [graphPath, permissions, httpMethod])
  }
}

/** @deprecated not used by Clarity */
exports.getDeferredApplink = function (s, f) {
  return f('getDeferredApplink is deprecated');

  exec(s, f, 'FacebookConnectPlugin', 'getDeferredApplink', [])
}

/** @deprecated not used by Clarity */
exports.activateApp = function (s, f) {
  return f('activateApp is deprecated');

  exec(s, f, 'FacebookConnectPlugin', 'activateApp', [])
}

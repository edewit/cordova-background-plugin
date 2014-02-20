/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

var exec = require('cordova/exec');

/**
 * This is a global variable called backgroundFetch exposed by cordova
 * @status Stable
 * @constructs backgroundFetch
 */
var backgroundFetch = {

    /**
     * Registers the device for background fetch.
     * @param {String} callback - callback to be executed to check if there is content availble
     * @returns {void}
     */
    register: function(callback) {
        return exec(null, null, 'BackgroundFetch', 'register', [{'callback': callback}]);
    },

    /**
     * Call this function to tell the OS if there was data or not so it can schedule the next fetch operation
     * @param {int} dataType - one of the BackgroundFetchResults or 0 new data 1 no data or 2 failed
     * @returns {void}
     * @example
        
        backgroundFetch.register({'ecb': 'fetchingContent'});
        ...

        function fetchingContent() {
            console.log('fetching stuff in background');
            //... actual fetching
            // if depening if there was new data or not...
            backgroundFetch.setContentAvailable(backgroundFetch.BackgroundFetchResult.NewData);
        });
     */
    setContentAvailable: function(dataType) {
        return exec(null, null, "BackgroundFetch", "setContentAvailable", [{type: dataType}]);
    },

    BackgroundFetchResult: {
        NewData: 0,
        NoData: 1,
        Failed: 2
    }
};

if (Object.freeze) {
    Object.freeze(backgroundFetch.BackgroundFetchResult);
}

module.exports = backgroundFetch;
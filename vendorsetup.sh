# 
# Copyright (C) 2026 The AviumUI Project
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Function to merge split APK parts (handles large files like MiuiCamera)
function merge_file_parts() {
    # Check if file parts exist before merging
    if ls $1.* 1> /dev/null 2>&1; then
        echo "Merging $1..."
        cat $1.* > $1
        rm -f $1.*
    fi
}

# Merge the MiuiCamera APK parts
merge_file_parts vendor/xiaomi/miuicamera-cupid/proprietary/system/priv-app/MiuiCamera/MiuiCamera.apk

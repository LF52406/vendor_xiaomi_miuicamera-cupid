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

# Reconstruct the input APK for Soong. Keep tracked parts, do not concatenate
# backup files, and preserve the previous APK if reconstruction is interrupted.
function merge_miuicamera_parts() (
    local apk="$1"
    local parts=("$apk".[0-9][0-9].part)
    if [[ ! -f "${parts[0]}" ]]; then
        # Older versions of this script removed the parts after merging.
        [[ -s "$apk" ]] || {
            echo "MiuiCamera: missing APK and split parts: $apk" >&2
            return 1
        }
        return 0
    fi
    local temporary
    temporary=$(mktemp "$apk.merge.XXXXXX") || return 1
    trap 'rm -f "$temporary"' EXIT
    cat "${parts[@]}" > "$temporary" || return 1
    # Avoid invalidating the incremental build on every envsetup invocation.
    if ! cmp -s "$temporary" "$apk"; then
        mv -f "$temporary" "$apk" || return 1
    fi
)

if ! merge_miuicamera_parts vendor/xiaomi/miuicamera-cupid/proprietary/system/priv-app/MiuiCamera/MiuiCamera.apk; then
    unset -f merge_miuicamera_parts
    return 1 2>/dev/null || exit 1
fi
unset -f merge_miuicamera_parts

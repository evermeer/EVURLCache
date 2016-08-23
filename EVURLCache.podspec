Pod::Spec.new do |s|

# ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#
#  These will help people to find your library, and whilst it
#  can feel like a chore to fill in it's definitely to your advantage. The
#  summary should be tweet-length, and the description more in depth.
#

s.name         = "EVURLCache"
s.version      = "2.10.0"
s.summary      = "NSURLCache subclass for handeling all web requests that use NSURLRequest"
s.description  = "This is a NSURLCache subclass for handeling all web requests that use NSURLRequest. (This includes UIWebView)"
s.homepage     = "https://github.com/evermeer/EVURLCache"


# ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#
#  Licensing your code is important. See http://choosealicense.com for more info.
#  CocoaPods will detect a license file if there is a named LICENSE*
#  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
#

s.license      = { :type => "MIT", :file => "LICENSE" }


# ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#
#  Specify the authors of the library, with email addresses. Email addresses
#  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
#  accepts just a name if you'd rather not provide an email address.
#
#  Specify a social_media_url where others can refer to, for example a twitter
#  profile URL.
#

s.authors    = {"evermeer" => "edwin@evict.nl"}
s.social_media_url   = "http://twitter.com/evermeer"

# ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#
#  If this Pod runs only on iOS or OS X, then specify the platform and
#  the deployment target. You can optionally include the target after the platform.
#
#s.ios.platform = :ios, "9.0"
#s.osx.platform = :osx, "10.11"


# ――― Deployment targets ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#
#  Specify the minimum deployment target
#
s.ios.deployment_target = "8.0"
s.osx.deployment_target = "10.9"
# s.watchos.deployment_target = '2.0'
# s.tvos.deployment_target = '9.0'


# ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#
#  Specify the location from where the source should be retrieved.
#  Supports git, hg, bzr, svn and HTTP.
#

s.source       = { :git => "https://github.com/evermeer/EVURLCache.git", :tag => s.version.to_s }

# ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#
#  CocoaPods is smart about how it includes source code. For source files
#  giving a folder will include any h, m, mm, c & cpp files. For header
#  files it will include any header in the folder.
#  Not including the public_header_files will make all headers public.
#

s.source_files  = 'EVURLCache/Pod/*'

# ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#
#  Link your library with frameworks, or libraries. Libraries do not include
#  the lib prefix of their name.
#

s.ios.frameworks = "Foundation", "MobileCoreServices"
s.osx.frameworks = "Foundation", "CoreServices"

# ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
#
#  If your library depends on compiler flags you can set them in the xcconfig hash
#  where they will only apply to your library. If you depend on other Podspecs
#  you can include multiple dependencies to ensure it works.

s.requires_arc = true

# In cocoapods version 1 ReachabilitySwift does not work as a dependency. For now the file is included in EVURLCache
# s.dependency "ReachabilitySwift"

end
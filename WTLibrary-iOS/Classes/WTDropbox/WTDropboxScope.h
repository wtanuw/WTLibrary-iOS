//
//  WTDropboxManager.h
//  MTankSoundSamplerSS
//
//  Created by Wat Wongtanuwat on 1/12/15.
//  Copyright (c) 2015 Wat Wongtanuwat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WTDB_SCOPE_NONE  @"" //
//Account Info  //Permissions that allow your app to view and manage Dropbox account info
#define WTDB_ACCOUNTINFO_WRITE  @"account_info.write" //View and edit basic information about your Dropbox account such as your profile photo
#define WTDB_ACCOUNTINFO_READ  @"account_info.read" //View basic information about your Dropbox account such as your username, email, and country
//Files and folders  //Permissions that allow your app to view and manage files and folders
#define WTDB_FILES_METADATA_WRITE @"files.metadata.write" //View and edit information about your Dropbox files and folders
#define WTDB_FILES_METADATA_READ @"files.metadata.read" //View information about your Dropbox files and folders
#define WTDB_FILES_CONTENT_WRITE @"files.content.write" //Edit content of your Dropbox files and folders
#define WTDB_FILES_CONTENT_READ @"files.content.read" //View content of your Dropbox files and folders
//Collaboration //Permissions that allow your app to view and manage sharing and collaboration settings
#define WTDB_SHARING_WRITE @"sharing.write" //View and manage your Dropbox sharing settings and collaborators
#define WTDB_SHARING_READ @"sharing.read" //View your Dropbox sharing settings and collaborators
#define WTDB_REQUESTS_WRITE @"file_requests.write" //View and manage your Dropbox file requests
#define WTDB_REQUESTS_READ @"file_requests.read" //View your Dropbox file requests
#define WTDB_CONTACTS_WRITE @"contacts.write" //View and manage your manually added Dropbox contacts
#define WTDB_CONTACTS_READ @"contacts.read" //View your manually added Dropbox contacts
//OpenID Scopes
//Scopes used for OpenID Connect.
//At this time, team-scoped apps cannot request OpenID Connect scopes.
//OpenID scopes must be explicity set in the "scope" parameter on /oauth2/authorize to be requested.
//Connect //Permissions that allow your app to access user login info
#define WTDB_PROFILE @"profile" //Read basic profile info
#define WTDB_OPENID @"openid" //Required for OpenID Connect flow
#define WTDB_EMAIL @"email" //Read basic email info

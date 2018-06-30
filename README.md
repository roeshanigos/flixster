# Project 2 - *TIPSTER*

**Flixster** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **20** hours spent in total

## User Stories

The following **required** functionality is complete:

- [X] User can view a list of movies currently playing in theaters from The Movie Database.
- [X] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [X] User sees a loading state while waiting for the movies API.
- [X] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [X] User sees an error message when there's a networking error.
- [X] Movies are displayed using a CollectionView instead of a TableView.
- [X] User can search for a movie.
- [X] All images fade in as they are loading.
- [ ] User can view the large movie poster by tapping on a cell.
- [ ] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [X] Customize the selection effect of the cell.
- [X] Customize the navigation bar.
- [X] Customize the UI.

The following **additional** features are implemented:

- [X] Movie View Controller has a nav bar with a (slight) transulcent feature.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. I want to have a walkthrough of how the code flows with the group. The network request portions are a bit confusing to me.
2. I also want to discuss how to create different setting of typed of movies like "now playing", "Marvel", or "Disney" movies.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='blob:https://imgur.com/3dd9d16b-6378-48d4-a244-75f4a9f4409f' title='Video Walkthrough' width='' alt='Video Walkthrough' />

<img src='blob:https://imgur.com/328383cd-7347-43c8-8246-8eeb5621402d' title='Video Walkthrough' width='' alt='Video Walkthrough' />

blob:https://imgur.com/4ee77a29-ad4b-4c1b-8680-96b707f868b6

<img src='blob:https://imgur.com/4ee77a29-ad4b-4c1b-8680-96b707f868b6' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

I definately had a problem with how the code works when you have a network requests. I always kep asking about what the syntax meant with some of the code. Loading the trailers was a problem for my pod and we walked trhough it together! Due to this, I understood more about how network requests work. There is still some confusion but my progress is growing!
## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library

## License

    Copyright [2018] [Roesha Nigos]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

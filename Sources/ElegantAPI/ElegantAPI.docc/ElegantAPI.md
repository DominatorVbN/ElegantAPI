# ``ElegantAPI``

Manage you API and Networking in you projects elegantly Changed More more more.

## Overview

ElegentAPI provides protocols, models and utilities to better manange your api calls and there paramtere, headers and method requirementes. The framework provide ``API`` protocol which have all the requirements like base url of request ``API/baseURL``,   method of request ``API/method`` and others. You can create `URLRequest` by calling ``API/getURLRequest()-uv02`` on type conforming to ``API`` protocol, and can hit it directly using `URLSession`.

![ElegantAPI](ElegantAPI.png)

## Topics

### Essestials

- <doc:GettingStarted>
- ``API``

### Logging

- ``NetworkLogger``

### Types

- ``Method``
- ``Task``
- ``ParameterEncoding``
- ``MultipartFormData``

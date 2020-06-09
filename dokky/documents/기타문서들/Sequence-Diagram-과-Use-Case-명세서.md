## 1. 프로젝트의 Sequence Diagram

## 1. 프로젝트의 Sequence Diagram 과 Use Case 명세서

#### 1) 소셜 연동 회원가입(네이버) Use Case 명세서

 	- 유스케이스명 : 소셜 연동 회원가입(네이버)

 	- 주액터 : 사용자, 일반관리자 
 	- 부액터 : 네이버 회원가입 연동시스템

 	- 목적 1: 주액터는 도키 커뮤니티의 모든 기능을 이용하기 위해서는 회원가입이 필요하다.
 	- 목적 2: 주액터의 주요 개인정보를 DB에 저장하지 않기 위해 소셜 연동 회원가입이 필요하다.
 	- 목적 3: 주액터의 편리한 가입을 위해 소셜 연동 회원가입이 필요하다.

 	- 사전 조건  : 주액터는 네이버 계정을 가지고 있어야 한다.
	
 	- 기본 흐름 : 
	
 	1) 주액터는 네이버 연동 회원가입 버튼을 클릭한다.
 	2) 부액터는 네이버 로그인 페이지를 보여준다.
 	3) 주액터는 자신의 네이버 계정을 입력한다.
 	4) 부액터는 필수 개인정보 제공 동의를 요구한다.
 	5) 주액터는 개인정보 제공에 동의한다.
 	6) 부액터는 시스템에게 오픈id를 전달
 	7) 시스템은 네이버로부터 받은 오픈 id 존재 여부를 데이터베이스에서  확인.
 	8) id가 존재 하지 않는다면 시스템은 회원가입 양식 항목을 보여준다.(닉네임,은행명,계좌번호)
 	9) 주액터는 회원정보 항목(닉네임,은행명,계좌번호)을 선택적으로 입력한다.
 	10) 주액터는 가입완료 요청을 한다.
 	11) 시스템은 중복된 닉네임 여부를 확인한다.
 	12) 시스템은 회원 정보를 회원 테이블에 저장한다.
 	13) 시스템은 회원가입을 완료하고 메인페이지를 보여준다.

 	- 대체흐름 1 :
 	2.a) 주액터가 이미 소셜 계정에 로그인이 되어있다면 4)단계부터 시작한다.

 	- 대체흐름 2 :
 	7.a) id 존재한다면 바로 로그인 되어 메인페이지로 이동한다.
 	
 	- 대체흐름 3 :
 	11.a) 닉네임이 중복 된다면 9)단계부터 다시 시작한다.
 	
#### 2) 소셜 연동 회원가입(네이버) Sequence Diagram
 	
[네이버 연동 회원가입 Sequence Diagram 상세 보러가기](https://www.draw.io/?lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1#R7V1bc%2BI4Fv41rtp9gNLFF%2FnRBtLp3e7ZrsnOTM%2B%2BOeAQ1wAmxrnNr1%2FJlnyRBBhig0mSSlWwLEviXD%2Bdc%2BQYeLR8%2BZIE6%2Fvv8SxcGAjMXgw8NhBCJgH0D2t5zVugaeG8ZZ5EM95WNtxEf4e8kT84f4xm4abWMY3jRRqt643TeLUKp2mtLUiS%2BLne7S5e1GddB3M%2BIygbbqbBQqxjaJXtf0Sz9D5vJ8gu26%2FDaH4v5oa2m9%2B5DaZ%2FzZP4ccVnNBC%2By37y28tAjMVn3twHs%2Fi50oQnBh4lcZzmn5Yvo3DByCsIlz93teVu8QWTcJU2eeD3eYw23l2S%2Fhbe%2FPsq%2FV%2BQ%2FPI6gCQf5ilYPIbie9gLOqB%2FF9Nx6bLTV04s%2B%2BExFjcGm4yVHu0A7fVLeZN%2BmvO%2F2Si3oiFep6KNrvFW7kfb8glFM6rNjSj11uzj43JxlQRL%2BtF%2Fvo%2FS8GYdTFn7MxVQ2nafLhf0ChZDVOnDSfYUJmn4Umni9PoSxsswTV5pF36XcOHg0m06nJXPpaBA6PJO9xUpKXoGXD7nxdglh%2BgHzqQDGIbhqRi2iOP1xXEMAlBjmYV1LLOByjJktcCy%2BOH6bvPtly9P9vf41Vz5g4fg68AFKssmY8P1DDIyJiPD9Q3aZeIZPjCoQWUtE4OJHvjtq0LVCrkY9W%2F4neI6t7DQboec2NWQD2mo14a864mnkfeJbxDT8MyMVGPDN1mLj1gjXVsj0trBkgnf6nazrsp%2B0lh%2FsodkFWLjO2wutsIrw3VZC6FryBZDvGzNY7YA2nJezjo6xTgtZ5HC2bGvZ2DeSMnGGwueE8M1z0xICMnZKYkVSnrTNE52meS8A%2FbZF40oHvoW3IaLH%2FEmSqN4RbvcxmkaL5kbYDf8AuuM4gV7blyinXIMbxHN2bNpLBn2%2BDFdRKtwVIA40BLtNUJsnpLyEFgadyxRPVzNPAZV6dUqXjE%2FOAs29%2BGME6dCp02axH8VMFQW2F00C2cC526hWIVCloZCoi0JF0EaPYW1wXVk4zP8iKMMdAiGWHX3CwGSSL%2BJH5NpyB%2BrolV5JNMdElSHX9JQaZDMw1QZitI6eK10W7MOm51rHiJcmwnjGpSmH%2FJBS0EpKPsW2bG7lZ2%2BC4tpOS0JCx1piBEof%2Bq4XVb%2FgwWnZiPaYD10D2L9dBFsNtF0F8PRBTBcsQ74WH7bewbawuHW%2BIdUjwuHGUzZDU0VfNgUr4JyHIaEaAeBhArQSyCfzrMNb5wNm%2BFMNhdtNIeKhFEvy2BrwN32lIpNmGhQk%2Bzfl9Fsxm76G7qVi1bzb%2BEdExRctvzKZQcXcipwA7diSZwGaXCbTcHAANc1uizLp7%2BUnSMwtAyLLnNEr2F5TX9Z9ySlaIIOHUSZrIfBJn0ON6lsIKv%2B02lpT2TWhU%2BzRSIaHRIBpfYxiBD%2Bj2VM9tqApsbEcc9sTLC5n38VVtVVJdOGMInoKpjujqli3MfzeBUsfpStu3XiLlosarA%2BtKdTRXHpnZnj3oKWoLsjxdZ0UB7ukJ4O1KhjOEZplbz%2BZPaOGjJ%2B%2BWf13viFG8P86tXYs0%2FKBXzXVzI5zMgleEdPt1%2B67RB3aAK3%2FKmJioXdYeWeS47U%2B52T9A8zYl2o%2Fs1mXjEG9Lqi8ldXPrZtWc777hsUk06O9A0KYpUH6to3mKpvwEMBJScZWMwijB7gcJBpw14YSuEjzqDkiD1IYWINSgrQOcmG9awDoOSeAL9O2Eqg%2BXanUuTaOLsQUJ2KHpx15lVMpwutrfgS2zar3gQMAXD3eJTsqgIPdruZvc6jcDM90X5ZaRXM0DyssGegzrW%2FQZjg3SPDgupnQ4bWYRus9gJ1F6d6iuM9OqTH0BmBJTiTQoUN%2FfChseCt62%2B6zDqIxPYp4siWGowyc4yQ%2Be3czxMioEEWXHKLRBqpoACf4QJfoAAv75aBBV%2FEoIq0Zo41GEawWDCKAwePJeTYI5bhjVTgcCm4wVZNDgYatZFTEi3anMMSSx8a7csOwyVF6uitgB8JjT6Vy7fUKIQ1fJPe5kFnnkVXFfhSsT2GGmyPT6ujDbD9u4dnuCE8k6Oq7bHBVvfIbuH%2FmmRW6GfbcKEo1hmXvpPlUahSeIbn1vfIQuNy5fKyKah7I6DUo3%2Fwj8Stb8cn2RhF%2Biafyubd6FRsUaP6Hh1lXyLfwecqS6gB%2BGdPNZXCoSGq4zVLUyNjQV3hZHdSohpWCLaJidayyhJxAgZLcRk2R57rw6w9XybJBJdacD8bwoNZcdm2OI7PF4d0ylAiuBFbijeWc4yX4SqghOJtTd2ujTXSZ3cnfZ0Eb4sw0AAMTeRU40C0BcAiz9BKIKgncA9apmxeHACHogz7YMQHoFlLJ8i1IyeO%2BTjqbq4FSXmXwF%2BOz9nmkTKwd6DOmd7Jbq%2Fv%2FIMASsoGwXEMhMjcM1LnHNTACygyNRQYMHjpix1ZBjK4l94BIUAFXtJnbQ4vy4DLmG3livSNT%2FrqjwGW9EsTXymc9mngIG6gce9u7wYR3qImZ4utO5oURx6l4KVuKAsbCvjrFjD53HX%2Frk6GT1r2D4nuLNh2r9FeXqJaeaI9pSbS1v1xNPXAvIL0D0CL9aqReuF4%2F6pGRCD0RMhif8aK4F6JhhLOOrpUBECwe6SuIQhpsHN4fy5NxpBYILE9Lg1ZZmd2WcWCtoCCkg%2BTAzaEHxF0TYOQr2OjiOjnfVnYZdTXsAuRzt5iATbOF6F3PmKEXlEJW3dCUcMHtzM%2BuBqU93Yv9C6DGhBJ5wuc47EK3jNSxx4JgdOCj75wsCh64XQnTisFy0qQg5wYYSCgOfaUlaOOxdn34rB2o4xK7tlEAsKzeurYqCI5Q4n0SGNSTxrBQKDBsZFPm8o1B%2B%2BK8btHH1KWNV0ZqXONvADHennRAomrELR2fkCphzx7hKBAglWjborDrJ7L08G85CiPOJv8lm%2FWE8T7qyL6auEdSY9PGaB2%2F3u%2FCFZkHQbXpj1e%2FX53jb4PVOSEmhwwFttJltt3eJEYTw3khQOTrOireJbyx1HSCg2KW7bx8fMs8UFyhylXpXOQJlIkr6vjxFrB05iDFjxK7xECQNK73t6QigS7R2oPE%2BgZqGYFHGY6ymgSFMo9YcqtTTNeVHZRIjjWlPt0FnfSs%2BATmjeH5rK6HHtaS1Xh7o5r6bn%2BmVKumrs9wcbulO%2Bwc%2Fw9PHHZF9U03aF4P6wwreK82REv2ZBf50XHGlIVVV7a1L62ajedKsAmRblOQweZv2onO%2BZE4bff282N7CB1KtqZg9S%2FdvjTQR6ATHfFrmzUSmzZtA4atmPd7MaEv0vxOJBxzQNXvZIHTZTT8vM9TXGKQWu7%2BZkFUkY6uDW32EvUWDjD4%2BGsPDxVxLVoN2vcU4OOpES7qXkFWWeYS%2F9Wck0MsYxX7axvlWpjL9%2FZyklXTaYIgY6OPumZo0KdXHt2MacIEe6uYFYV52K0xjI1jNFZ6s4Yo3m5j0K797dhlKtT3IbVKd2xQaMfH48NpOG%2Bvahxbp8PH7J%2BUY6fkBOqw8t%2FVg4e%2F%2Fn888G6S5LBv5KNlx66N3t3r6WmHKkXi5cu%2FfBcAK5Xi5t1aHDGXPDPR%2FRijZ%2BuB79e%2FfHl9TpcT8iPgeY8QWcvNL4JHx7DFcUCCIyjYJ4Ey224QZv0qyorb9JjCWQekoVU8pdb9FkjwFtVfCAVAQx0%2F0bIaknH6WX5L6VyuSj%2FdRee%2FB8%3D)

#### 3) 소셜 연동 로그인(네이버) Use Case 명세서

 	- 유스케이스명 : 소셜 연동 로그인(네이버)

 	- 주액터 : 사용자, 일반관리자 
 	- 부액터 : 소셜 연동시스템

 	- 목적 1: 주액터는 도키 커뮤니티의 모든 기능을 이용하기 위해서는 로그인이 필요하다.
 	- 목적 2: 주액터의 편리한 로그인을 위해 소셜 연동이 필요하다.

 	- 사전 조건  : 주액터는 네이버 계정으로 도키에 가입되어 있어야 한다.
 	
 	- 기본 흐름 : 
 	
 	1) 주액터는 네이버 로그인 버튼을 클릭한다.
 	2) 시스템은 네이버 로그인 페이지를 보여준다.
 	3) 주액터는 자신의 네이버 계정을 입력한다.
 	4) 시스템은 네이버로부터 받은 오픈 id 존재 여부를 데이터베이스에서  확인한다.
 	5) 시스템은 아이디가 존재한다면 메인페이지를 보여준다.

 	- 대체흐름 1 :
 	2.a) 계정에 로그인 되어있다면 메인페이지를 바로 보여준다.
 	
 	- 대체흐름 2 :
 	5.a) 아이디가 존재 하지 않는다면 소셜 연동 회원가입 명세서의 4)부터 시작한다.
 	
#### 4) 소셜 연동 로그인(네이버) Sequence Diagram

[네이버 연동 로그인 Sequence Diagram 상세 보러가기](https://www.draw.io/?lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1#R7Vxbc6M4Fv41qpp9SAoQF%2FFobGdmameruia1NbtPW9goNtsYubGSOPvrV1cukuJL2k6YTPslcCQEnOuncw4BcLrZ%2F9zk2%2FU%2FSIErEHjFHsAZCAKIILyN2AGnvUhaEKSBpKyaspA0vyPcl%2F%2FDiugp6mNZ4N1gIiWkouV2SFySusZLOqDlTUOeh9MeSDW86zZfYYtwv8wrTdVvwOl%2FlAVdK7ofp93AL7hcrdXNURDLgUW%2B%2FLpqyGOt7liTGsuRTa6XUW%2B5W%2BcFee6R4BzAaUMIlUeb%2FRRXnLeaZ%2Fo6%2BqIfFMBsTTcVO%2FHZoRi%2Be%2BVi%2F5SL2Xs1uKb927223rfi4Wn1383692b%2Bcu%2Bj%2FyR%2FX329UWJ%2ByqtHfZN5BlAIJiGYT0E6A1nIKVnAiewOnJiAzBPT7kCaCmIGJj5Ip2A%2BARkbRfpaxEbv8bdHXC8ZU71Zma%2BafGO9GMV79grZjjbkK56SijSMLgQBs4eyqgxSjwkPpKZKHYNQn6uF%2BfgTbmjJ9GRSlaua0TZlUfDBLFeEJeMebpzsVALgS%2BB9j6TY%2BzMmG0ybFzZFjd74CVR6%2BKIpfqSU4LmnlZG2m3VPI0NFy5UtrNr1O6GyAyXXM2QMLRlPlpTx05QCU%2B8tP3zcVHJCx77f8gWuvpBdSUvCubYglJINm1Dxgaw1IS0oEMAH8XOIgJLtUIbkkVZlzeSufYN3KXFEyDPE4SFbHKFDGMm1hBE6DG4G0glAU2E0GUg9YUYeQNLa5gAxpfL%2B%2BaslMNMOenrfsws%2FvhQ7IbTYmTi0O3hPfkZnO7BTuB3nG66k9WK3FcyLK%2B6fFs2A%2F%2FG3R%2B75Ba9vdoLZEzbBj7d7eZEaZ0cr8df2nYyCMuE42cFEPPOMPwCjfLSwvXB8wo7dwr7jouWMCzgHZZBiFM7WVvAfy80kGh8zE4uZs8xtIJLI1FIRW5tCIP1w1obJ%2BFiLbD01uYTrYsKBb4dqiny3xoXiVI%2BJEhVpUMspeF%2FSf%2FE4eRvEUJ3%2FW5ynzKfI89leBVJx8tI7%2BYKbkr0mBz2HI%2B2OPDZLfCiWKeHjYoDObVn1BBE55KBpDa5yWj4Nkb5LOOoOX0jJHrnns5hEbxH02l881IzUkLd8QbVKHzmfu7DPSMOlad6sMLWWZiLPX3rTtnzCztK3lnVvV8H0uir4dqUJ4LiUJkVD0aIL6cyRdUeoMnpTMj6dgfG4dCZOB7L1L6Qyh5cdo8bocD0%2BjUHj0pjQH3qD1MgTvFlnji08Rq1xJJ2uA488kRPS8Mi%2F9bzwrwyPovg6oe7YwiPUweC8WLes8t2uXB7SvOCQroxJBUyhvx0Um9k1a61XxHwxIZ4Xfj6NEKGZmnm7ENMPl6ErGMh0226b18CVcFvKLDNPtjWrxU8iQRGw23u9o7%2FxQy5MT6TnHvJNWb3Ia9r0Hggg5AFhjasnzHPU1shwkV6OL9nujTH5lHywJs0mr4bDz0oP%2BHgin1MMVpiyUHPDXnVZ1ivn9bw4cqPKFXxYVSwGw2VdCG3l417v0cQgbfJ698AW1cvzApea8EyaYnj3%2FuVdbezG4HkQRS2vjeOO80W521a54npZ8yR%2Fx5WK5LT%2FQGa21L8FsrJ0KJd7qO7UzeTJKzZBJ6%2FaPDDy1YKTGExmIvEVqawhYsTwVmsi02ypjCqRazoZVb96XpcU3zNmcvJzkxt1jlcdy1kljcA0WO3Re94Hukoa0Hvd03xXtiuwC0wWh3psUEGdkaMMRDNO6UEu0tA1WZE6r3pAbAj%2B%2BlnExKgQisITjpdLq5zIRookXXiXKi6lyILwjrTjgTBweTk4akvj2I0FKhslY8kJqjSWUPsjOdRKxlFo%2B36sZZkyO%2B8Z7N1dBuPYVNLRAzTmGm693s9wFCjyBsPBG5XIBvPI9C3XBm92QS74%2FrDNAvMcpKh37RRMElGgZRdGPJCr6A7VaJqAiYju7I5ymo7f7kBtNX%2Bc3DaioNJv%2BIHrDOwovys1gq%2F1sTSE5jRfiFt4VhjMOH7ybiMeEBmQijK%2FO5cxkgXGKanZ0nkp1B7nO%2FqMd%2FRYdLwI6ghN1IEQsoIdcpiU1pDLBzu7fAml6okifuqp2vrEU3qUohMUc8J1CkmN8zgaHCBG3R4wF8syTXQhxjdBQ5cf7PTxKrgRQRuuuEV4NbxyXpn002zfLbedfA%2BOOLLUtSPACXXGvwD2b9n%2BUdhfG%2FP1c%2BqRF4yg5eD4TiIdl9V%2F0E7iVET4fhsJaCdtYx24jaatFieq4ItUg1zKUB76dabILBTLuTwCT0cbgVOzBczlM9okzfs0Bp%2BXMPgsAfjI9iwJL7M9i1NT4KYgrxybob1lT7ildZbj6%2F3TnO%2Bf2u7%2BibTBmO%2BlVENg2oHhDI3VxGILWLkw7vuamKNl9fPjo9jsQmhV%2Fwg%2BCuKrCcLeL14JICXhGJoOjgKkkfdUXQwgHVl3hKlWeMK%2B%2BPP5jNA3fEb84XuqK%2FfQdi4jTQyXwXgxRpcx8qY6%2FZ3HxZvqzIVH6DTC8xIAnwXLM6RxCMtz538JLB96nrXwSQpwMfEGlniR3jWfCuNln8NUFFhCfsmfBcbHjo823xfGhye0OPyofrbO0xCfKZYzsJtpz%2B%2B8hQ5dGRLZE8SFBVzdaa7PQe1vQfUnpZpAtrTXbbQw5zGavOErHUi9b7fvmnyD36sbycxxxL4DtLm3euhqxupoVYgymfhov%2FV1uk6rniecZip8pSdKs%2BP0mH5kxSdHM5JTDNdzmSdkPn64TJUeMcUXmsZxRlOImWe21rq2z7QzLX6ou0KYMaVhl0hUqcWenQ0K7sdbPP48Fhm5UmDpZSySnXb%2FhUbKsftXP3D%2Bfw%3D%3D)

#### 5) 자체  로그인(슈퍼 관리자) Use Case 명세서

 	- 유스케이스명 : 자체  로그인(슈퍼 관리자)

 	- 주액터 - 슈퍼관리자

 	- 목적 : 슈퍼관리자는 일반 관리자의 권한 관리를 위해 로그인이 필요하다.

 	- 사전 조건 : 슈퍼관리자의 계정을 미리 데이터베이스에 생성해둬야 한다.

 	- 기본 흐름 : 
	
 	1) 슈퍼관리자는 슈퍼관리자 로그인 버튼을 클릭한다.
 	2) 시스템은 아이디와 비밀번호를 요구한다.
 	3) 슈퍼관리자는 자신의 계정을 입력해 로그인 한다.
 	4) 시스템은 슈퍼관리자의 정보를 확인한다
 	5) 시스템은 정보가 맞으면 로그인을 완료시킨다

 	- 대체흐름 1 :   
 	3.a) 아이디를 잘못 입력하거나, 없는 아이디를 입력했을 경우 
 	3.a.1) 아이디 확인을 요구하는 모달창이 띄어진다.
 	3.a.2) 단계 2)을 다시 수행한다.
 	
 	- 대체흐름 2 : 
 	3.b) 비밀번호를 잘못 입력했을 경우
 	3.b.1) 비밀번호가 확인을 요구하는 모달창이 띄어진다.
 	3.b.2) 단계 2)을 다시 수행한다.  
 	
#### 6) 자체  로그인(슈퍼 관리자) Sequence Diagram

[자체  로그인(슈퍼 관리자) Sequence Diagram 상세 보러가기 ](https://www.draw.io/?lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1&title=Untitled%20Diagram.drawio#R7Vzfc6M2EP5rmLk%2BxAMIgXg0dtJ2ep25uUyn7VMHG8Wmh5EP4zjpX98VEr8kOXFyxvYldy8Ru7DY%2B%2B1qV5%2Fks9Bk9fBzEa%2BXv7OEZpZrJw8WmlquizEJ4A%2BXPAqJ64aukCyKNBEypxXcpv9RKbSldJsmdNO7sWQsK9N1XzhneU7nZU8WFwXb9W%2B7Y1n%2Fret4QTXB7TzOaukIt%2FI%2F06RcSrnjh63iF5oulvLlxPWFYhbPvywKts3lG3OWU6FZxbUZ%2BS03yzhhu44IXVtoUjBWitHqYUIz7tnaZ%2FVz5WP9QS0ULctVBhcODCv1zZ6HnUMehu9V0Lzsvm6fva%2FJ3f3i39Xyc3H9eOuQf4LfFl%2BuPE%2BYuY%2Bzbf0W18%2FAYHTHwG73%2Ff7XLasVV5sqBsZwg%2BOvH1oljBbyb2VlVgvYuqxl8Bln6n0gEy%2Bsxcp3B9%2Bv%2BXC7ym6KeAXDaLdMS3q7judcvoPINvnnnhYlfVBip3WZ08AIyUHZipbFI9wiH7hycCgxlJlxheuQ33WirMmDZSfCXCKFsQzuRWO%2FRQkGEqgXgIbdU4GWMbb%2BDlHzXQU1Qgyo2diAGsJDoWYA7XpihdcWhBgMIteKIBlhHFljxwon1vXYigIrItVtUxh84CMytgiIphYB0aR6YMyfJOJJ3xpPGrs%2FgfqWft3SHLzt2tM0XgAKGkrgao7epizYFzphGStAXs2DEDdplimiDlocfFkNXK%2B%2Bloa5nuOYwjQ9ztJFDrJVmiRcGcVSMAdMaXEs3Imn4O442AA8NqWrNxTuSMN9PC%2FBn0%2Fkirihdd%2FHeEazT2yTlinjXpuxsmQrnp9cETUVrAbKctFd9c8AQcmUjGPbMktzwL0uzfbRJk%2BiwmEb8tAzgBEMBYah3EEqhZBTImuiKhshoewqoao8ItBb2H%2F8qgGm5kEn7jt54fjHcidCmjsDUzE6pT99gz8ji9xYxKvmKNcai0ltwiV8Uov4TEe8s3vT1uaK83sz0Lw5jSrvaSEqhBCZUjjlJYD7lljh2X0b4EPy%2FrSuJYaWSfESzZMxX4u0lS6JN0uaSE91nCgqZb3OaNsWmmjLlGed1vGIqR%2BpZQXN4jK975s3eUm%2B4RNLq06wiffGtTUo4Oy%2BlQ3bFnMqH%2BwuJEy2RgTZzT9fhdtWYCzjYkFLzTS4O37s3LbmN2ye%2FhZO%2F12B3Vv1wEAYbSOl8fXrgye8jOCBF1YQPdVkorNGWUj6gUH6YIVKWBwccc%2FYPULA9SaXI4RM3WIOFTP0IS3%2F4s3aKPCwvP6b60Z21Ynz6%2BmD7Oaqi8fOxSdapPANeefdafeOEoGCUThbBPrhk5ESqG3%2BwSGoGFamoUuMQBNLMEgEthEnI9B%2BzxHoYH%2BYSfA5wxcYg%2B7LZsF5Fm826fypyHO%2Fi2YLkFJBfzXqrrqK1mztgfloIDrvE0SkrhBfD2J4dgxNxUBwuJt1nFsmyngu2CROFxeL2Ydq0elyxrEz4gxjBaZdEcx38SrNHsUzYCherSslQrwgLGl2TzkXpWn6RjosdcBZ6p5OfEquzFmxirO%2BeifjgOsD8TkrZUZLKDVX8FXnab4wPs9J0CtJS3K1ZCZ76jRPquDkervz0SplWcT55g6M1ub5PpK8YceKpP%2F27uPtFtSV4nMX48bXyrj1fJJu1lksvZ7mnMxrvZKxuOx%2BIJXyd0bWk5yz1ArOhlMOY846Cy0R1A4MHEk%2FcPp5WtEVWJI9BITeqLNfIMJtz36BZKJPsrOj7hGE9ZzdmV%2BQiZxE9v655Nt2CHSqWPNQxw2ybIMYRxaeckmnqWJFuWQLlsdZp9Xqt3dd7idQuP6KQqb%2BfK5tDIAmCcKZfSyaOCR4z9zY26zRcXCcwYAw7Ype6IJfchOifjwbXD%2BYgfP3xHiIdkrLZbjuZOzNTYR8Xw3Si%2B%2FBQuKOcAuurcwUAazJO1rbfWUQORgHI932aTs0fSvFPaQ2Q%2FW9tkLS2QWYWOOg3g7G9R4xlHAktWEg94jH9a5xXaTN1Vjbqz14l1d2PB%2FpHY8L1Eo%2By1BB%2B7adC1bGZTyrXmFrtS7ibZANiEHVg34IR057LQohVL8Jy8F0nFaRTONNuaOb8rkSeJTWwvOUWCJIr2jEkDaD7UG7%2Bs4SEsH1sgMFtRZV3SBEkM07vV43WG%2BZ8mdtHoCmbvBVbZ9pimvDcJCeMDD0hEbk3MGQO2Dv4R30hAHCh%2FWEwx3jOBmhj223Q6faozAMz0%2BnHtJhhu%2BxwyTqgbGzN5joZauXt8LXcZy6zaAyg%2FhH6hV9dWryT9woIn394I3MhVnW46mkbKKQN4pSKJpAaAt9XunlIZOwLecRudQyHarkerOp163S6JT9FTrgeMnbq9J%2BqKaC8ZitjsNwx%2FtcDQfc5IbLT%2FWJJGkWRbK9rbrXSD84dakR75v60pNGvHcAV%2FmDxajzxFXZBV%2FlLg9vRwKNqtCMDVyBPAODhaOn1oZRszbUa5FYHpKWt5B3Yr4y5WvGcXWksSUqqrwNuU08vdSMdbB6WJcYTpeeOGUNh3V%2FpOzeZrIPn%2Ff6DXyM8DO2hs5Xnf3xG2ox5NnVtHyyCezkWI%2FceZ5FvNyEdFRETT8NCU%2BZkNiwUPvWeXTynU2TKiqm39cZe8jhUNGzRXPf2%2BvlNcbNM%2F0a4pS9PH7Zkf23QmM4SC0XgcsJqFdWnzA4wNrA9Qe%2F7Pz8m0FSOwX4TUjqBwGPCiVctr9kF7e3%2F1kAuv4f)
Qe%2F7Pz8m0FSOwX4TUjqBwGPCiVctr9kF7e3%2F1kAuv4f)

#### 7) 글 목록 조회 Use Case 명세서

- 유스케이스명 : 글 목록 조회

- 액터명 : 주액터 - 사용자, 일반관리자, 슈퍼관리자

- 목적 : 메인화면 또는 게시판 종류별 글 목록을 조회 한다. 

- 기본 흐름 1 : 

1) 주액터는 메인 화면에 접속한다
2) 시스템은 데이터 베이스에서 실시간 게시글, 한달간 인기글 , 한달간 기부글 목록을 가져온다.
3) 시스템은 실시간 게시글 5개, 한단갈 인기글 5개 , 한달간 기부글 5개 순으로 화면을 보여준다.

- 기본 흐름 2 :
1) 주액터는 게시판 종류중 하나에 접속한다(전체글보기, 공지사항, 자유게시판, 묻고답하기, 칼럼/TECH, 정기모임/스터디)
2) 시스템은 데이터 베이스에서 해당 게시판의 리스트를 가져온다
3) 시스템은 해당 리스트의 게시글을 10개씩 최신순으로 화면을 보여준다.

- 일반화관계 USE CASE 목록

* 최신순 조회
* 조회순 조회
* 댓글순 조회
* 좋아요순 조회
* 기부순 조회
* 새 글 작성
* 글 검색
* 글 상세페이지 조회 


#### 8) 글 목록 조회  Sequence Diagram

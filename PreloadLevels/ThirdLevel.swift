//
//  ThirdLevel.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 2/3/24.
//

import Foundation

struct ThirdLevel: PreloadedLevel {
    var level = Optional("{\"id\":\"level3\",\"isPreloadedLevel\":false,\"gameObjects\":[{\"type\":\"Peg\",\"data\":\"eyJpZCI6IkMzM0RFNzExLUVDOTctNEFCNS1CNzdCLTg0RjQ1OTgzQ0EwMiIsImlzQWN0aXZlIjpmYWxzZSwib3JpZW50YXRpb24iOjAsImhhbmRsZU92ZXJsYXBDb3VudCI6MCwibWluRGlzdGFuY2UiOjAsIm1heFdpZHRoIjo1MCwibWF4RGlzdGFuY2UiOjIwMCwiaGFzQmxhc3RlZCI6ZmFsc2UsImFjdGl2ZUlkeCI6MCwiaXNEaXNhcHBlYXIiOmZhbHNlLCJpc0hhbmRsZU92ZXJsYXAiOmZhbHNlLCJpbml0aWFsV2lkdGgiOjI1LCJpc1Nwb29rIjpmYWxzZSwiY2VudGVyIjp7InhDb29yZCI6MzU1LCJ5Q29vcmQiOjgyMC41LCJyYWRpYWwiOjg5NC4wMDUxNzMzNjMxMDc1OSwidGhldGEiOjEuMTYyNDUyOTg2MzIzMTg1NiwidXBwZXJCb3VuZCI6My4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5YIjowLCJsb3dlckJvdW5kIjotMy4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5ZIjowfSwiaXNCbGFzdCI6ZmFsc2UsImhhbGZXaWR0aCI6MjUsImhlYWx0aCI6MTAwLCJuYW1lIjoiZ2xvd09iamVjdCIsImluaXRpYWxUb3AiOnsieENvb3JkIjowLCJ5Q29vcmQiOjAsInJhZGlhbCI6MCwidGhldGEiOjAsInVwcGVyQm91bmQiOjMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWCI6MCwibG93ZXJCb3VuZCI6LTMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWSI6MH19\"},{\"type\":\"Peg\",\"data\":\"eyJpZCI6IjY5ODc4MDU4LUQxOUEtNDFGQi05QjI1LTg2RjBCNTU3NkNDNSIsImlzQWN0aXZlIjpmYWxzZSwib3JpZW50YXRpb24iOjAsImhhbmRsZU92ZXJsYXBDb3VudCI6MCwibWluRGlzdGFuY2UiOjAsIm1heFdpZHRoIjo1MCwibWF4RGlzdGFuY2UiOjIwMCwiaGFzQmxhc3RlZCI6ZmFsc2UsImFjdGl2ZUlkeCI6MCwiaXNEaXNhcHBlYXIiOmZhbHNlLCJpc0hhbmRsZU92ZXJsYXAiOmZhbHNlLCJpbml0aWFsV2lkdGgiOjI1LCJpc1Nwb29rIjpmYWxzZSwiY2VudGVyIjp7InhDb29yZCI6NDY1LjUsInlDb29yZCI6ODMyLCJyYWRpYWwiOjk1My4zNjk5NDM5MzU3MjExNSwidGhldGEiOjEuMDYwNjkyMzgwODg4NzY5NiwidXBwZXJCb3VuZCI6My4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5YIjowLCJsb3dlckJvdW5kIjotMy4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5ZIjowfSwiaXNCbGFzdCI6ZmFsc2UsImhhbGZXaWR0aCI6MjUsImhlYWx0aCI6MTAwLCJuYW1lIjoiZ2xvd09iamVjdCIsImluaXRpYWxUb3AiOnsieENvb3JkIjowLCJ5Q29vcmQiOjAsInJhZGlhbCI6MCwidGhldGEiOjAsInVwcGVyQm91bmQiOjMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWCI6MCwibG93ZXJCb3VuZCI6LTMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWSI6MH19\"},{\"type\":\"Peg\",\"data\":\"eyJpZCI6IjE5QTUzQTZGLUZGMTQtNEZFMS05QjE2LTQ5MEM0RUJDOThEQyIsImlzQWN0aXZlIjpmYWxzZSwib3JpZW50YXRpb24iOjAsImhhbmRsZU92ZXJsYXBDb3VudCI6MCwibWluRGlzdGFuY2UiOjAsIm1heFdpZHRoIjo1MCwibWF4RGlzdGFuY2UiOjIwMCwiaGFzQmxhc3RlZCI6ZmFsc2UsImFjdGl2ZUlkeCI6MCwiaXNEaXNhcHBlYXIiOmZhbHNlLCJpc0hhbmRsZU92ZXJsYXAiOmZhbHNlLCJpbml0aWFsV2lkdGgiOjI1LCJpc1Nwb29rIjpmYWxzZSwiY2VudGVyIjp7InhDb29yZCI6NDMxLjUsInlDb29yZCI6NDUzLjUsInJhZGlhbCI6NjI1Ljk4MjgyNzI0MDQ5MjI3LCJ0aGV0YSI6MC44MTAyNTE4MDE4MDMwMzIzNiwidXBwZXJCb3VuZCI6My4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5YIjowLCJsb3dlckJvdW5kIjotMy4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5ZIjowfSwiaXNCbGFzdCI6ZmFsc2UsImhhbGZXaWR0aCI6MjUsImhlYWx0aCI6MTAwLCJuYW1lIjoiZ2xvd09iamVjdCIsImluaXRpYWxUb3AiOnsieENvb3JkIjowLCJ5Q29vcmQiOjAsInJhZGlhbCI6MCwidGhldGEiOjAsInVwcGVyQm91bmQiOjMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWCI6MCwibG93ZXJCb3VuZCI6LTMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWSI6MH19\"},{\"type\":\"Peg\",\"data\":\"eyJpZCI6IkQ4QTJDNjVELTgwNjEtNDdBQy1CQkQzLTU2Q0E0NzBFMDhBMCIsImlzQWN0aXZlIjpmYWxzZSwib3JpZW50YXRpb24iOjAsImhhbmRsZU92ZXJsYXBDb3VudCI6MCwibWluRGlzdGFuY2UiOjAsIm1heFdpZHRoIjo1MCwibWF4RGlzdGFuY2UiOjIwMCwiaGFzQmxhc3RlZCI6ZmFsc2UsImFjdGl2ZUlkeCI6MCwiaXNEaXNhcHBlYXIiOmZhbHNlLCJpc0hhbmRsZU92ZXJsYXAiOmZhbHNlLCJpbml0aWFsV2lkdGgiOjI1LCJpc1Nwb29rIjpmYWxzZSwiY2VudGVyIjp7InhDb29yZCI6NDM5LCJ5Q29vcmQiOjUyNywicmFkaWFsIjo2ODUuODkzNTc3NzUwOTUxMDcsInRoZXRhIjowLjg3NjI0NDcyMjI0MDYwMjM1LCJ1cHBlckJvdW5kIjozLjE0MTU5MjY1MzU4OTc5MzEsIm9yaWdpblgiOjAsImxvd2VyQm91bmQiOi0zLjE0MTU5MjY1MzU4OTc5MzEsIm9yaWdpblkiOjB9LCJpc0JsYXN0IjpmYWxzZSwiaGFsZldpZHRoIjoyNSwiaGVhbHRoIjoxMDAsIm5hbWUiOiJnbG93T2JqZWN0IiwiaW5pdGlhbFRvcCI6eyJ4Q29vcmQiOjAsInlDb29yZCI6MCwicmFkaWFsIjowLCJ0aGV0YSI6MCwidXBwZXJCb3VuZCI6My4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5YIjowLCJsb3dlckJvdW5kIjotMy4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5ZIjowfX0=\"},{\"type\":\"Peg\",\"data\":\"eyJpZCI6IkEyMDc0M0UwLUJBMjYtNDQ4NC1BMDNCLUM4RjI2NjE4NDVBRSIsImlzQWN0aXZlIjpmYWxzZSwib3JpZW50YXRpb24iOjAsImhhbmRsZU92ZXJsYXBDb3VudCI6MCwibWluRGlzdGFuY2UiOjAsIm1heFdpZHRoIjo1MCwibWF4RGlzdGFuY2UiOjIwMCwiaGFzQmxhc3RlZCI6ZmFsc2UsImFjdGl2ZUlkeCI6MCwiaXNEaXNhcHBlYXIiOmZhbHNlLCJpc0hhbmRsZU92ZXJsYXAiOmZhbHNlLCJpbml0aWFsV2lkdGgiOjI1LCJpc1Nwb29rIjpmYWxzZSwiY2VudGVyIjp7InhDb29yZCI6NDQ3LCJ5Q29vcmQiOjYwMSwicmFkaWFsIjo3NDkuMDA2MDA3OTg2NTg0NzksInRoZXRhIjowLjkzMTMwMDUzNzAzNjg2MjIyLCJ1cHBlckJvdW5kIjozLjE0MTU5MjY1MzU4OTc5MzEsIm9yaWdpblgiOjAsImxvd2VyQm91bmQiOi0zLjE0MTU5MjY1MzU4OTc5MzEsIm9yaWdpblkiOjB9LCJpc0JsYXN0IjpmYWxzZSwiaGFsZldpZHRoIjoyNSwiaGVhbHRoIjoxMDAsIm5hbWUiOiJnbG93T2JqZWN0IiwiaW5pdGlhbFRvcCI6eyJ4Q29vcmQiOjAsInlDb29yZCI6MCwicmFkaWFsIjowLCJ0aGV0YSI6MCwidXBwZXJCb3VuZCI6My4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5YIjowLCJsb3dlckJvdW5kIjotMy4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5ZIjowfX0=\"},{\"type\":\"Peg\",\"data\":\"eyJpZCI6IkU4ODVBQjBBLUI2RkEtNDMzMC1BQTA5LTk1ODAzOUIwMjQyRiIsImlzQWN0aXZlIjpmYWxzZSwib3JpZW50YXRpb24iOjAsImhhbmRsZU92ZXJsYXBDb3VudCI6MCwibWluRGlzdGFuY2UiOjAsIm1heFdpZHRoIjo1MCwibWF4RGlzdGFuY2UiOjIwMCwiaGFzQmxhc3RlZCI6ZmFsc2UsImFjdGl2ZUlkeCI6MCwiaXNEaXNhcHBlYXIiOmZhbHNlLCJpc0hhbmRsZU92ZXJsYXAiOmZhbHNlLCJpbml0aWFsV2lkdGgiOjI1LCJpc1Nwb29rIjpmYWxzZSwiY2VudGVyIjp7InhDb29yZCI6NDU4LjUsInlDb29yZCI6NjY3LCJyYWRpYWwiOjgwOS4zODk0MzAzNzMyOTA2OCwidGhldGEiOjAuOTY4NTcyNjEyMTA2NTA3NDcsInVwcGVyQm91bmQiOjMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWCI6MCwibG93ZXJCb3VuZCI6LTMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWSI6MH0sImlzQmxhc3QiOmZhbHNlLCJoYWxmV2lkdGgiOjI1LCJoZWFsdGgiOjEwMCwibmFtZSI6Imdsb3dPYmplY3QiLCJpbml0aWFsVG9wIjp7InhDb29yZCI6MCwieUNvb3JkIjowLCJyYWRpYWwiOjAsInRoZXRhIjowLCJ1cHBlckJvdW5kIjozLjE0MTU5MjY1MzU4OTc5MzEsIm9yaWdpblgiOjAsImxvd2VyQm91bmQiOi0zLjE0MTU5MjY1MzU4OTc5MzEsIm9yaWdpblkiOjB9fQ==\"},{\"type\":\"Peg\",\"data\":\"eyJpZCI6IjcyMzMxOEY2LUUzMTEtNEI1OS05RDk3LTBBQjcyNkQ4RDBCQSIsImlzQWN0aXZlIjpmYWxzZSwib3JpZW50YXRpb24iOjAsImhhbmRsZU92ZXJsYXBDb3VudCI6MCwibWluRGlzdGFuY2UiOjAsIm1heFdpZHRoIjo1MCwibWF4RGlzdGFuY2UiOjIwMCwiaGFzQmxhc3RlZCI6ZmFsc2UsImFjdGl2ZUlkeCI6MCwiaXNEaXNhcHBlYXIiOmZhbHNlLCJpc0hhbmRsZU92ZXJsYXAiOmZhbHNlLCJpbml0aWFsV2lkdGgiOjI1LCJpc1Nwb29rIjpmYWxzZSwiY2VudGVyIjp7InhDb29yZCI6NjM0LjUsInlDb29yZCI6NzQ3LCJyYWRpYWwiOjk4MC4xMDE2NTI4OTExNjgyMSwidGhldGEiOjAuODY2NjUyMDk2MzY3MzM4ODYsInVwcGVyQm91bmQiOjMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWCI6MCwibG93ZXJCb3VuZCI6LTMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWSI6MH0sImlzQmxhc3QiOmZhbHNlLCJoYWxmV2lkdGgiOjI1LCJoZWFsdGgiOjEwMCwibmFtZSI6InNvbGlkT2JqZWN0IiwiaW5pdGlhbFRvcCI6eyJ4Q29vcmQiOjAsInlDb29yZCI6MCwicmFkaWFsIjowLCJ0aGV0YSI6MCwidXBwZXJCb3VuZCI6My4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5YIjowLCJsb3dlckJvdW5kIjotMy4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5ZIjowfX0=\"},{\"type\":\"Peg\",\"data\":\"eyJpZCI6Ijc3Q0Y4OThDLUU4MUUtNDIyNy05RDAwLTA4RTE0RTdDQzI3MCIsImlzQWN0aXZlIjpmYWxzZSwib3JpZW50YXRpb24iOjAsImhhbmRsZU92ZXJsYXBDb3VudCI6MCwibWluRGlzdGFuY2UiOjAsIm1heFdpZHRoIjo1MCwibWF4RGlzdGFuY2UiOjIwMCwiaGFzQmxhc3RlZCI6ZmFsc2UsImFjdGl2ZUlkeCI6MCwiaXNEaXNhcHBlYXIiOmZhbHNlLCJpc0hhbmRsZU92ZXJsYXAiOmZhbHNlLCJpbml0aWFsV2lkdGgiOjI1LCJpc1Nwb29rIjpmYWxzZSwiY2VudGVyIjp7InhDb29yZCI6NzYyLCJ5Q29vcmQiOjYxMS41LCJyYWRpYWwiOjk3Ny4wMjQxODA4Njc1OTc1OCwidGhldGEiOjAuNjc2MjU5NDgzMjU1ODA0OTgsInVwcGVyQm91bmQiOjMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWCI6MCwibG93ZXJCb3VuZCI6LTMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWSI6MH0sImlzQmxhc3QiOmZhbHNlLCJoYWxmV2lkdGgiOjI1LCJoZWFsdGgiOjEwMCwibmFtZSI6InNvbGlkT2JqZWN0IiwiaW5pdGlhbFRvcCI6eyJ4Q29vcmQiOjAsInlDb29yZCI6MCwicmFkaWFsIjowLCJ0aGV0YSI6MCwidXBwZXJCb3VuZCI6My4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5YIjowLCJsb3dlckJvdW5kIjotMy4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5ZIjowfX0=\"},{\"type\":\"Peg\",\"data\":\"eyJpZCI6IkI2QzM5Q0ZGLTZFNzgtNDRBMy05QUQ5LTVEMDYyRTM3RkEwMiIsImlzQWN0aXZlIjpmYWxzZSwib3JpZW50YXRpb24iOjAsImhhbmRsZU92ZXJsYXBDb3VudCI6MCwibWluRGlzdGFuY2UiOjAsIm1heFdpZHRoIjo1MCwibWF4RGlzdGFuY2UiOjIwMCwiaGFzQmxhc3RlZCI6ZmFsc2UsImFjdGl2ZUlkeCI6MCwiaXNEaXNhcHBlYXIiOmZhbHNlLCJpc0hhbmRsZU92ZXJsYXAiOmZhbHNlLCJpbml0aWFsV2lkdGgiOjI1LCJpc1Nwb29rIjpmYWxzZSwiY2VudGVyIjp7InhDb29yZCI6NjkyLjUsInlDb29yZCI6Njc5LCJyYWRpYWwiOjk2OS44NDM5MzA3NDM0OTg1LCJ0aGV0YSI6MC43NzU1NTUyNDM5NDkxMDc1OCwidXBwZXJCb3VuZCI6My4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5YIjowLCJsb3dlckJvdW5kIjotMy4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5ZIjowfSwiaXNCbGFzdCI6dHJ1ZSwiaGFsZldpZHRoIjoyNSwiaGVhbHRoIjoxMDAsIm5hbWUiOiJhY3Rpb25PYmplY3QiLCJpbml0aWFsVG9wIjp7InhDb29yZCI6MCwieUNvb3JkIjowLCJyYWRpYWwiOjAsInRoZXRhIjowLCJ1cHBlckJvdW5kIjozLjE0MTU5MjY1MzU4OTc5MzEsIm9yaWdpblgiOjAsImxvd2VyQm91bmQiOi0zLjE0MTU5MjY1MzU4OTc5MzEsIm9yaWdpblkiOjB9fQ==\"},{\"type\":\"Peg\",\"data\":\"eyJpZCI6IjMzREY5NTMwLTZFNUYtNERCRi1BMEM1LUM3NThBQThGN0I5MSIsImlzQWN0aXZlIjpmYWxzZSwib3JpZW50YXRpb24iOjAsImhhbmRsZU92ZXJsYXBDb3VudCI6MCwibWluRGlzdGFuY2UiOjAsIm1heFdpZHRoIjo1MCwibWF4RGlzdGFuY2UiOjIwMCwiaGFzQmxhc3RlZCI6ZmFsc2UsImFjdGl2ZUlkeCI6MCwiaXNEaXNhcHBlYXIiOmZhbHNlLCJpc0hhbmRsZU92ZXJsYXAiOmZhbHNlLCJpbml0aWFsV2lkdGgiOjI1LCJpc1Nwb29rIjpmYWxzZSwiY2VudGVyIjp7InhDb29yZCI6NTY3LCJ5Q29vcmQiOjgwMCwicmFkaWFsIjo5ODAuNTU1NDU0ODMxNTk2OTksInRoZXRhIjowLjk1NDIyMTk4NzI3Njg3OTU3LCJ1cHBlckJvdW5kIjozLjE0MTU5MjY1MzU4OTc5MzEsIm9yaWdpblgiOjAsImxvd2VyQm91bmQiOi0zLjE0MTU5MjY1MzU4OTc5MzEsIm9yaWdpblkiOjB9LCJpc0JsYXN0Ijp0cnVlLCJoYWxmV2lkdGgiOjI1LCJoZWFsdGgiOjEwMCwibmFtZSI6ImFjdGlvbk9iamVjdCIsImluaXRpYWxUb3AiOnsieENvb3JkIjowLCJ5Q29vcmQiOjAsInJhZGlhbCI6MCwidGhldGEiOjAsInVwcGVyQm91bmQiOjMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWCI6MCwibG93ZXJCb3VuZCI6LTMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWSI6MH19\"},{\"type\":\"OscillateObject\",\"data\":\"eyJpZCI6IjRCN0ZFNkIzLTRFMUUtNEYxNC1BMkRDLTBDMUNENDIzNEM3OSIsImlzQWN0aXZlIjpmYWxzZSwib3JpZW50YXRpb24iOjAsImhhbmRsZU92ZXJsYXBDb3VudCI6MCwibWluRGlzdGFuY2UiOjAsIm1heFdpZHRoIjo1MCwibWF4RGlzdGFuY2UiOjIwMCwiaGFzQmxhc3RlZCI6ZmFsc2UsImFjdGl2ZUlkeCI6MCwiaXNEaXNhcHBlYXIiOmZhbHNlLCJpc0hhbmRsZU92ZXJsYXAiOmZhbHNlLCJpbml0aWFsV2lkdGgiOjI1LCJpc1Nwb29rIjpmYWxzZSwiY2VudGVyIjp7InhDb29yZCI6MjYyLCJ5Q29vcmQiOjc4NCwicmFkaWFsIjo4MjYuNjE5NjIyMzE3MzAyNjMsInRoZXRhIjoxLjI0ODI4MDY2MTYwNjQ2NTIsInVwcGVyQm91bmQiOjMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWCI6MCwibG93ZXJCb3VuZCI6LTMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWSI6MH0sImlzQmxhc3QiOmZhbHNlLCJoYWxmV2lkdGgiOjI1LCJoZWFsdGgiOjEwMCwibmFtZSI6Im9zY2lsbGF0ZU9iamVjdCIsImluaXRpYWxUb3AiOnsieENvb3JkIjowLCJ5Q29vcmQiOjAsInJhZGlhbCI6MCwidGhldGEiOjAsInVwcGVyQm91bmQiOjMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWCI6MCwibG93ZXJCb3VuZCI6LTMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWSI6MH19\"},{\"type\":\"OscillateObject\",\"data\":\"eyJpZCI6IjIwRjYwRkVBLTBBNzYtNDUyMC04RUZCLTc1QTdGRjhDNzFBNSIsImlzQWN0aXZlIjpmYWxzZSwib3JpZW50YXRpb24iOjAsImhhbmRsZU92ZXJsYXBDb3VudCI6MCwibWluRGlzdGFuY2UiOjAsIm1heFdpZHRoIjo1MCwibWF4RGlzdGFuY2UiOjIwMCwiaGFzQmxhc3RlZCI6ZmFsc2UsImFjdGl2ZUlkeCI6MCwiaXNEaXNhcHBlYXIiOmZhbHNlLCJpc0hhbmRsZU92ZXJsYXAiOmZhbHNlLCJpbml0aWFsV2lkdGgiOjI1LCJpc1Nwb29rIjpmYWxzZSwiY2VudGVyIjp7InhDb29yZCI6MjIzLCJ5Q29vcmQiOjczMiwicmFkaWFsIjo3NjUuMjE0MzQ5MDU1MjE3MzMsInRoZXRhIjoxLjI3NTA4MzcwNjIxNDkxNTgsInVwcGVyQm91bmQiOjMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWCI6MCwibG93ZXJCb3VuZCI6LTMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWSI6MH0sImlzQmxhc3QiOmZhbHNlLCJoYWxmV2lkdGgiOjI1LCJoZWFsdGgiOjEwMCwibmFtZSI6Im9zY2lsbGF0ZU9iamVjdCIsImluaXRpYWxUb3AiOnsieENvb3JkIjowLCJ5Q29vcmQiOjAsInJhZGlhbCI6MCwidGhldGEiOjAsInVwcGVyQm91bmQiOjMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWCI6MCwibG93ZXJCb3VuZCI6LTMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWSI6MH19\"},{\"type\":\"OscillateObject\",\"data\":\"eyJpZCI6Ijk3RjczNUE1LUJGQkYtNDM0MS1CMDA5LTBBQTJGN0JEQzQ4OSIsImlzQWN0aXZlIjpmYWxzZSwib3JpZW50YXRpb24iOjAsImhhbmRsZU92ZXJsYXBDb3VudCI6MCwibWluRGlzdGFuY2UiOjAsIm1heFdpZHRoIjo1MCwibWF4RGlzdGFuY2UiOjIwMCwiaGFzQmxhc3RlZCI6ZmFsc2UsImFjdGl2ZUlkeCI6MCwiaXNEaXNhcHBlYXIiOmZhbHNlLCJpc0hhbmRsZU92ZXJsYXAiOmZhbHNlLCJpbml0aWFsV2lkdGgiOjI1LCJpc1Nwb29rIjpmYWxzZSwiY2VudGVyIjp7InhDb29yZCI6MTc2LjUsInlDb29yZCI6NjY3LjUsInJhZGlhbCI6NjkwLjQ0MDgwMTIyNzczNzQ0LCJ0aGV0YSI6MS4zMTIyOTMxMDYyODg5NjkxLCJ1cHBlckJvdW5kIjozLjE0MTU5MjY1MzU4OTc5MzEsIm9yaWdpblgiOjAsImxvd2VyQm91bmQiOi0zLjE0MTU5MjY1MzU4OTc5MzEsIm9yaWdpblkiOjB9LCJpc0JsYXN0IjpmYWxzZSwiaGFsZldpZHRoIjoyNSwiaGVhbHRoIjoxMDAsIm5hbWUiOiJvc2NpbGxhdGVPYmplY3QiLCJpbml0aWFsVG9wIjp7InhDb29yZCI6MCwieUNvb3JkIjowLCJyYWRpYWwiOjAsInRoZXRhIjowLCJ1cHBlckJvdW5kIjozLjE0MTU5MjY1MzU4OTc5MzEsIm9yaWdpblgiOjAsImxvd2VyQm91bmQiOi0zLjE0MTU5MjY1MzU4OTc5MzEsIm9yaWdpblkiOjB9fQ==\"},{\"type\":\"Peg\",\"data\":\"eyJpZCI6Ijc3NDhDNkJBLTk0MzItNEQ0Ni05RTdFLUJBMDE5OTAxMUUzMyIsImlzQWN0aXZlIjpmYWxzZSwib3JpZW50YXRpb24iOjAsImhhbmRsZU92ZXJsYXBDb3VudCI6MCwibWluRGlzdGFuY2UiOjAsIm1heFdpZHRoIjo1MCwibWF4RGlzdGFuY2UiOjIwMCwiaGFzQmxhc3RlZCI6ZmFsc2UsImFjdGl2ZUlkeCI6MCwiaXNEaXNhcHBlYXIiOmZhbHNlLCJpc0hhbmRsZU92ZXJsYXAiOmZhbHNlLCJpbml0aWFsV2lkdGgiOjI1LCJpc1Nwb29rIjpmYWxzZSwiY2VudGVyIjp7InhDb29yZCI6NTI4LjUsInlDb29yZCI6MzUxLjUsInJhZGlhbCI6NjM0LjcxNjA3ODI1ODYxNzkzLCJ0aGV0YSI6MC41ODY5MTAxODUzNjczMTAzMiwidXBwZXJCb3VuZCI6My4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5YIjowLCJsb3dlckJvdW5kIjotMy4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5ZIjowfSwiaXNCbGFzdCI6ZmFsc2UsImhhbGZXaWR0aCI6MjUsImhlYWx0aCI6MTAwLCJuYW1lIjoic29saWRPYmplY3QiLCJpbml0aWFsVG9wIjp7InhDb29yZCI6MCwieUNvb3JkIjowLCJyYWRpYWwiOjAsInRoZXRhIjowLCJ1cHBlckJvdW5kIjozLjE0MTU5MjY1MzU4OTc5MzEsIm9yaWdpblgiOjAsImxvd2VyQm91bmQiOi0zLjE0MTU5MjY1MzU4OTc5MzEsIm9yaWdpblkiOjB9fQ==\"},{\"type\":\"Peg\",\"data\":\"eyJpZCI6IjI1MEE5NzIxLTNEQkQtNEEwMC04NjM0LUJCMjQ1NzAxRkVCNSIsImlzQWN0aXZlIjpmYWxzZSwib3JpZW50YXRpb24iOjAsImhhbmRsZU92ZXJsYXBDb3VudCI6MCwibWluRGlzdGFuY2UiOjAsIm1heFdpZHRoIjo1MCwibWF4RGlzdGFuY2UiOjIwMCwiaGFzQmxhc3RlZCI6ZmFsc2UsImFjdGl2ZUlkeCI6MCwiaXNEaXNhcHBlYXIiOmZhbHNlLCJpc0hhbmRsZU92ZXJsYXAiOmZhbHNlLCJpbml0aWFsV2lkdGgiOjI1LCJpc1Nwb29rIjpmYWxzZSwiY2VudGVyIjp7InhDb29yZCI6NjA4LCJ5Q29vcmQiOjM0MCwicmFkaWFsIjo2OTYuNjA4OTI5MDI2ODk2NywidGhldGEiOjAuNTA5ODg3MTE5NTg0Mzk5OTIsInVwcGVyQm91bmQiOjMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWCI6MCwibG93ZXJCb3VuZCI6LTMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWSI6MH0sImlzQmxhc3QiOmZhbHNlLCJoYWxmV2lkdGgiOjI1LCJoZWFsdGgiOjEwMCwibmFtZSI6InNvbGlkT2JqZWN0IiwiaW5pdGlhbFRvcCI6eyJ4Q29vcmQiOjAsInlDb29yZCI6MCwicmFkaWFsIjowLCJ0aGV0YSI6MCwidXBwZXJCb3VuZCI6My4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5YIjowLCJsb3dlckJvdW5kIjotMy4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5ZIjowfX0=\"},{\"type\":\"Peg\",\"data\":\"eyJpZCI6IkM0MzQ3M0FBLUEzMEEtNEEyQy05RjlGLTQ0Mzk2MjU3MTc2MSIsImlzQWN0aXZlIjpmYWxzZSwib3JpZW50YXRpb24iOjAsImhhbmRsZU92ZXJsYXBDb3VudCI6MCwibWluRGlzdGFuY2UiOjAsIm1heFdpZHRoIjo1MCwibWF4RGlzdGFuY2UiOjIwMCwiaGFzQmxhc3RlZCI6ZmFsc2UsImFjdGl2ZUlkeCI6MCwiaXNEaXNhcHBlYXIiOmZhbHNlLCJpc0hhbmRsZU92ZXJsYXAiOmZhbHNlLCJpbml0aWFsV2lkdGgiOjI1LCJpc1Nwb29rIjpmYWxzZSwiY2VudGVyIjp7InhDb29yZCI6MzQzLCJ5Q29vcmQiOjM3NC41LCJyYWRpYWwiOjUwNy44Mzc4MTg1OTk1OTk3NiwidGhldGEiOjAuODI5MjcyNDI4Nzg5MDg2MTQsInVwcGVyQm91bmQiOjMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWCI6MCwibG93ZXJCb3VuZCI6LTMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWSI6MH0sImlzQmxhc3QiOmZhbHNlLCJoYWxmV2lkdGgiOjI1LCJoZWFsdGgiOjEwMCwibmFtZSI6InNvbGlkT2JqZWN0IiwiaW5pdGlhbFRvcCI6eyJ4Q29vcmQiOjAsInlDb29yZCI6MCwicmFkaWFsIjowLCJ0aGV0YSI6MCwidXBwZXJCb3VuZCI6My4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5YIjowLCJsb3dlckJvdW5kIjotMy4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5ZIjowfX0=\"},{\"type\":\"Peg\",\"data\":\"eyJpZCI6IjIzQjM2OEMxLTBGQzYtNEYwQi1BMTg1LUU0NjcwNjFDOEYzMiIsImlzQWN0aXZlIjpmYWxzZSwib3JpZW50YXRpb24iOjAsImhhbmRsZU92ZXJsYXBDb3VudCI6MCwibWluRGlzdGFuY2UiOjAsIm1heFdpZHRoIjo1MCwibWF4RGlzdGFuY2UiOjIwMCwiaGFzQmxhc3RlZCI6ZmFsc2UsImFjdGl2ZUlkeCI6MCwiaXNEaXNhcHBlYXIiOmZhbHNlLCJpc0hhbmRsZU92ZXJsYXAiOmZhbHNlLCJpbml0aWFsV2lkdGgiOjI1LCJpc1Nwb29rIjpmYWxzZSwiY2VudGVyIjp7InhDb29yZCI6MjY5LjUsInlDb29yZCI6Mzc3LjUsInJhZGlhbCI6NDYzLjgyODA5MzE1NTIxMiwidGhldGEiOjAuOTUwNzk3NDY3MzczMjQzNTUsInVwcGVyQm91bmQiOjMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWCI6MCwibG93ZXJCb3VuZCI6LTMuMTQxNTkyNjUzNTg5NzkzMSwib3JpZ2luWSI6MH0sImlzQmxhc3QiOmZhbHNlLCJoYWxmV2lkdGgiOjI1LCJoZWFsdGgiOjEwMCwibmFtZSI6InNvbGlkT2JqZWN0IiwiaW5pdGlhbFRvcCI6eyJ4Q29vcmQiOjAsInlDb29yZCI6MCwicmFkaWFsIjowLCJ0aGV0YSI6MCwidXBwZXJCb3VuZCI6My4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5YIjowLCJsb3dlckJvdW5kIjotMy4xNDE1OTI2NTM1ODk3OTMxLCJvcmlnaW5ZIjowfX0=\"}]}")
}

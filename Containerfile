FROM docker.io/library/alpine:latest as builder

RUN apk add --no-cache clang21-dev clang21-static llvm21-dev llvm21-static llvm21-gtest libxml2-dev cmake make git
RUN git clone --depth=1 --recursive https://github.com/MaskRay/ccls /ccls

WORKDIR /ccls

RUN cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release \
                        -DCMAKE_CXX_COMPILER=/usr/bin/clang++-21 \
                        -DCMAKE_PREFIX_PATH=/usr/lib/llvm21
RUN cmake --build Release
RUN cmake --build Release --target install

FROM docker.io/library/alpine:latest

RUN apk add --no-cache clang21

COPY --from=builder /usr/local/bin/ccls /usr/local/bin/ccls

CMD ["/usr/local/bin/ccls"]

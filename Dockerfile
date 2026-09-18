ARG FRR_VERSION=10.7.1

FROM quay.io/frrouting/frr:${FRR_VERSION}

ARG FRR_VERSION

ENV FRR_VERSION=${FRR_VERSION}

RUN apk add --no-cache libcap \
	&& setcap cap_net_admin,cap_net_raw,cap_net_bind_service+ep /usr/lib/frr/zebra \
	&& setcap cap_net_admin,cap_net_raw,cap_net_bind_service+ep /usr/lib/frr/bgpd \
	&& setcap cap_net_admin,cap_net_raw,cap_net_bind_service+ep /usr/lib/frr/bfdd

EXPOSE 179 2601 2602 2603 2604 2605 2606 2607 2608 2609 2610

USER frr
